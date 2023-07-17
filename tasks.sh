# wt: write-tasks
# wt ctx $context sets the task context
# wt $file $task adds a task to the task list in $file under the right $context
# wt $file prints the first 10 tasks in $file if no task is given
# wt done clears the task context
wt() {
  file="$1"

  if [ ! -f "$file" ]; then
    touch "$file"
  fi

  # shift the args to remove the file name
  shift 1

  if [ "$#" -eq 0 ]; then
    # show the first 10 lines from $file
    head "$file" | bat -l markdown
    return 0
  fi

  if [ "$1" = "done" ]; then
    # clear the task context
    export TASK_CONTEXT=""
    return 0
  fi

  if [ "$1" = "ctx" ]; then
    # set the task context and shift the args
    shift 1
    export TASK_CONTEXT="$*"
    return 0
  fi


  if [ -z "$TASK_CONTEXT" ]; then
    # append to the end of short-tasks if no context is set
    echo "- $*" >> "$file"
    return 0
  fi

  # append task at the top of heading determined by $TASK_CONTEXT
  gsed -i "/${TASK_CONTEXT}/a - $*" "$file"
}


# st: short-tasks
# st $task adds a task to the short task list
# st prints the first 10 short tasks
st() {
  wt ~/.short-tasks.md "$@"
}

# lt: long-tasks
# lt $task adds a task to the long task list
# lt prints the first 10 long tasks
lt() {
  wt ~/.long-tasks.md "$@"
}

tasks(){
  if [ "$#" -eq 0 ]; then
    print_tasks
    return 0
  fi
}

print_tasks(){
  echo "\nShort Tasks:"
  head ~/.short-tasks.md | bat -l markdown
  echo "\n\nLong Tasks:"
  head ~/.long-tasks.md | bat -l markdown
}

alias vst='nvim ~/.short-tasks.md'
alias vlt='nvim ~/.long-tasks.md'
alias t='tasks'
