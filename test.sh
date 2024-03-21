#!/bin/bash

# auditctl -l | awk '/^ *-a *always,exit/ \
# &&/ -F *arch=b[2346]{2}/ \
# &&/ -S/ \
# &&(/adjtimex/ \
#     ||/settimeofday/ \
#     ||/clock_settime/ ) \
# &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
# auditctl -l | awk '/^ *-w/ \
# &&/\/etc\/localtime/ \
# &&/ +-p *wa/ \
# &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
#!/bin/bash

# Function to check audit rules using grep (for simpler checks)
check_audit_rules_grep() {
  file="/home/ubuntu/Desktop/test.rules"
  if grep -w "ass" $file; then
    echo "Rule found in $file"
  else
    echo "Rule not found in $file"
  fi
}

check_audit_rules_grep
