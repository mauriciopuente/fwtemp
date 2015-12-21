#!/bin/bash

security authorizationdb write system.preferences allow


security authorizationdb write system.preferences.network allow
security authorizationdb write system.services.systemconfiguration.network allow
