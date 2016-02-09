import sqlite3, shutil
import os, argparse, re, unittest

#
# target platform: Mac/Linux
#
# scan all files on disk, see if the file ID's are in the FW database, if NOT, then move the file
# to a subdirectory within the /fwxserver area.
#
# Impl:
# - scan D|R files, ignore the checksums
# - identify if missing, then nuke the file
#
# Missing is:
# - fileID doesn't exist in the file table
#

TEMP_FOLDER = '/fwxserver/unused/Data Folder'

parser = argparse.ArgumentParser(prog='move_unused_files.py')
parser.add_argument("--database_folder", default='/fwxserver/DB', help="the full path to the admin.sqlite file (/fwxserver/DB)")
parser.add_argument("--database_name", default='admin.sqlite', help="the name of the database file (admin.sqlite)")
parser.add_argument("--data_folder", default='/fwxserver/Data Folder', help="the folder containing all the data (/fwxserver/Data Folder)")
parser.add_argument("--move", action="store_true", help="move unused files to the temp directory")
parser.add_argument("--purge", action="store_true", help="delete FWxxx.FWD directories that are empty")

re_data_file = re.compile('.*/(\d+).FWD/FW(\d+)([D|C|R])')

'''
Checks to see if a particular directory is empty - in the sense that it contains ONLY a .DS_Store
file but nothing else (so this will work on linux / mac).
'''


def is_empty_enough(dir_path):
    allowed = [
        ".DS_Store",
    ]

    for root, dirs, files in os.walk(dir_path, followlinks=False):
        if (len(dirs)):
            return False

        for f in files:
            if f not in allowed:
                return False

    return True


'''
Moves the file pointed to by full_path, which is composed of folder_path, file_id and file_type
into the TEMP_FOLDER.  If a file with the same name exists at the destination it will be deleted.
'''


def move_file(full_path, temp_folder, folder_part, file_id, file_type):
    dest_dir = os.path.join(temp_folder, folder_part)
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
    dest_full_path = os.path.join(dest_dir, 'FW%d%s' % (file_id, file_type))
    if os.path.exists(dest_full_path):
        print "removed existing file at destination:", dest_full_path
        os.remove(dest_full_path)
    shutil.move(full_path, dest_full_path)
    print "moved %s to %s" % (full_path, dest_full_path)


'''
Determines whether or not a give file_id is present in the admin.sqlite database.
'''
class DatabaseLookup(object):
    sql_count_file = r"SELECT count(id) FROM file"
    sql_all_fileids = r"SELECT id FROM file"
    sql_get_file = r"SELECT id, name, dataForkSize, resourceForkSize FROM file WHERE id = ?"
    sql_find_file = r"SELECT id, filesetID FROM file WHERE id = %s"

    db = None
    db_path = None
    cur = None

    def __init__(self, data_folder, name):
        super(DatabaseLookup, self).__init__()
        self.db_path = os.path.join(data_folder, name)

    def open(self):
        if not os.path.exists(self.db_path):
            raise Exception("The path to the database does not exist: %s" % self.db_path)
        self.db = sqlite3.connect(self.db_path)
        self.cur = self.db.cursor()

    def is_fileid_in_database(self, file_id):
        itr = self.cur.execute(self.sql_find_file % file_id)
        try:
            next(itr)
            return True
        except StopIteration:
            return False

    def get_all_file_ids(self):
        return self.cur.execute(self.sql_all_fileids)

    def get_file_count(self):
        return int(self.cur.execute(self.sql_count_file).fetchone()[0])

    def get_file_data(self, file_id):
        itr = self.cur.execute(self.sql_get_file, (file_id,))
        res = itr.fetchone()
        if not res:
            return None
        return { "id": res[0], "name": res[1], "dataSize": res[2], "resourceSize": res[3] }


'''
The scanner portion - which scans the data folder to find all the files matching a pattern
and then it'll check to see if the file is in the DB or not
'''


def scan_for_missing_files(source_folder, temp_folder, lookup, do_move=False, do_purge=False):
    num_files_processed = 0
    num_dirs_processed = 0
    total_to_process = int(lookup.get_file_count())

    for root, dirs, files in os.walk(source_folder, followlinks=False, topdown=False):

        for f in files:
            full_path = os.path.join(root, f)
            result = re_data_file.match(full_path)
            if result:
                folder_id = int(result.group(1))
                file_id = int(result.group(2))
                file_type = result.group(3)
                if file_id <= 200:
                    continue

                if not lookup.is_fileid_in_database(file_id):
                    if do_move:
                        move_file(full_path, temp_folder, "%d.FWD" % folder_id, file_id, file_type)
                    else:
                        print "would move %s at %s to %s" % (file_id, full_path, temp_folder)
            else:
                print "no RE match on:", full_path

            num_files_processed += 1
            if (int(num_files_processed) % (total_to_process / 1000)) == 0:
                print "FILES checked: %d" % num_files_processed

        for d in dirs:
            num_dirs_processed += 1
            if (num_dirs_processed % 1000) == 0:
                print "DIRS checked: %d" % num_dirs_processed

            if not d.endswith(".FWD"):
                continue

            full_dir = os.path.join(root, d)
            if is_empty_enough(full_dir):
                if do_purge:
                    shutil.rmtree(full_dir)
                    print "removed:", full_dir
                else:
                    print "would remove empty directory:", full_dir

    print "total files checked:", num_files_processed
    print "total directories checked:", num_dirs_processed


'''
Please note: by default the program will perform a dry-run, nothing will be changed - the files to be removed
will be printed to the console.
To make the program perform the move, use the --move command line option.
To make the program purge empty data directories, use the --purge command line option.
'''
if __name__ == "__main__":
    args = parser.parse_args()

    lookup = DatabaseLookup(args.database_folder, args.database_name)
    lookup.open()

    scan_for_missing_files(args.data_folder, TEMP_FOLDER, lookup, do_move=args.move, do_purge=args.purge)
