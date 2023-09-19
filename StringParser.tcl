# Global delimiter
set delimiter "#"

# String to parse. Contains \r\n to send more than 1 string
set request "#SD#04012011;135515;5544.6025;N;03739.6834;E;35;215;110;7\r\n#M#Delivered\r\n#XYZ#invalid data"
set lines [split [string trim $request "\r"] "\n"]

puts "Initial string : $request"

# params data - data to parse
# return response -"object-like" array 
proc parseData {package_type data} {
    array set response [list\
        package_type $package_type]

    switch -exact $package_type {
        "SD" {
            set data [split $data ";"]
            array set response [list \
            timestamp [clock scan "[lindex $data 0] [lindex $data 1]" -format {%d%m%Y %H%M%S} -gmt true]\
            latitude "[lindex $data 2],[lindex $data 3]"\
            longitude "[lindex $data 4],[lindex $data 5]"\
            speed [lindex $data 6]\
            course [lindex $data 7]\
            height [lindex $data 8]\
            sats [lindex $data 9]]
            }
        "M" {
            array set response [list \
            message $data]
            }
    }

    return [array get response];
}

# params package_type - package_type to validate
# return bool
# Validate if package_type is supported
proc validatePackageType {package_type} {
    switch -exact $package_type {
        "SD" {return true}
        "M" {return true}
        default {
            puts "Not implemented package type"
            return false;
        }
    }
}

puts "----"

foreach line $lines {
    puts "Request : $line\n" 

    # Split string by global delimiter 
    set request [split $line $delimiter];
    # Get package type
    set package_type [lindex $request 1];
    # Get data
    set data [lindex $request 2];

    # Print parsed data if package_type is valid
    if {[validatePackageType $package_type]} {
        array set response [parseData $package_type $data];
        puts "Response :"
        foreach {param value} [array get response] {
            puts "  $param : $value" 
        }
        unset response 
    }
    puts "----"
}


