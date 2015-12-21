#!/bin/bash

security authorizationdb write system.preferences allow


security authorizationdb write system.preferences.security allow
security authorizationdb write system.preferences.location allow

#security authorizationdb write system.services.systemconfiguration.network
