#!/usr/bin/env fish

set SCRIPT_DIR (pushd (dirname (status --current-filename)); and pwd; and popd)

source $SCRIPT_DIR/__git.fish
source $SCRIPT_DIR/__ssh.fish


function pi_load_styles
  set -g pi_vcs_style          a8a8a8
  set -g pi_ssh_style          afaf5f
  set -g pi_normal_style       5fd7ff
  set -g pi_error_style        ff005f
  set -g pi_rebasing_style     ff005f
  set -g pi_rev_style          5fafd7
  set -g pi_branch_style       87ffd7
  set -g pi_dirty_style        CD6155
  set -g pi_left_right_style   ffff00
  set -g pi_commit_since_style 8787af
  set -g pi_fade_style         6c6c6c
  set -g pi_venv_style         8a8a8a
end

function pi_git_prompt
  set -l is_git (plib_is_git)
  if [ $is_git = "1" ]
    set_color $pi_vcs_style
    echo -ne "G "

    set_color $pi_branch_style
    plib_git_branch
    set_color normal

    echo -ne " "
    set_color $pi_rev_style
    plib_git_rev
    set_color normal

    set_color $pi_commit_since_style
    echo -ne " ["(plib_git_commit_since)"]"
    set_color normal

    set_color $pi_dirty_style
    plib_git_dirty
    set_color normal

    set_color $pi_left_right_style
    plib_git_left_right
    echo -ne " "
    set_color normal

    set -l rebasing (plib_is_git_rebasing)
    if [ $rebasing = "1" ]
      set_color $pi_rebasing_style
      echo -ne "(rebasing)"
      set_color normal
    end
  end
end

function pi_prompt_left
  set -l last_st $status

  echo -ne " "
  if not test $last_st -eq 0
    set_color $pi_error_style
  else
    set_color $pi_normal_style
  end

  echo -ne (prompt_pwd | awk -F '/' '{print $NF}')

  if not test $last_st -eq 0
    set_color normal
    set_color $pi_fade_style
    echo -ne " ("$last_st")"
  end
  set_color normal
  echo -ne " "
end

function pi_prompt_right
  pi_git_prompt
end

function fish_prompt
  pi_load_styles
  pi_prompt_left
end

function fish_right_prompt
  pi_load_styles
  pi_prompt_right
end
