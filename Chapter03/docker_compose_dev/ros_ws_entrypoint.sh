#!/bin/bash

# Source the ROS 2 setup script
source /opt/ros/jazzy/setup.bash

# Source the workspace setup script if it exists
if [ -f "$ROS_WS/install/setup.bash" ]; then
    source "$ROS_WS/install/setup.bash"
fi

# Execute any additional commands passed to the entrypoint
exec "$@"