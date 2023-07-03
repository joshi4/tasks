# lt: long-tasks
# lt $task adds a task to the long task list
# lt prints the first 10 long tasks
lt() {
  if [ "$#" -eq 0 ]; then
    head ~/.long-tasks.md | bat -l markdown
    return 0
  fi

  if [ "$1" = "ctx" ]; then
    shift 1
    export TASK_CONTEXT="$@"
    return 0
  fi

  if [ "$1" = "done" ]; then
    export TASK_CONTEXT=""
    return 0
  fi

  if [ -z "$TASK_CONTEXT" ]; then
    echo "- $@" >> ~/.long-tasks.md
    return 0
  fi

  sed -i "/${TASK_CONTEXT}/a - $*" ~/.long-tasks.md
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


