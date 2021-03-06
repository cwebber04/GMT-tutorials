#!/bin/bash
# insert a justfont javascript after the </head> tag in these output html files generated by sphinx
# insert a disqus javascript before the <div role="contentinfo"> tag in these output html files generated by sphinx
# by Whyjay Zheng, first edition on 2016/1/12

html_files=$(ls _build/html/*.html)

jf_string=$(cat _static/jf_code.txt)
disqus_string=$(cat _static/disqus_code.txt)
github_ribbon=$(cat _static/github_ribbon.txt)

# refer to the escape characters...
# http://unix.stackexchange.com/questions/32907/what-characters-do-i-need-to-escape-when-using-sed-in-a-sh-script
jf_string=${jf_string//\\/\\\\}     # changes all "\" to "\\"
jf_string=${jf_string//\[/\\\[}     # changes all "[" to "\["
jf_string=${jf_string//\]/\\\]}     # changes all "]" to "\]"
jf_string=${jf_string//\$/\\\$}     # changes all "$" to "\$"
jf_string=${jf_string//\./\\\.}     # changes all "." to "\."
jf_string=${jf_string//\*/\\\*}     # changes all "*" to "\*"
jf_string=${jf_string//\^/\\\^}     # changes all "^" to "\^"
jf_string=${jf_string//\//\\\/}     # changes all "/" to "\/"
jf_string=${jf_string//\"/\\\"}     # changes all '"' to '\"'

disqus_string=${disqus_string//\\/\\\\}     # changes all "\" to "\\"
disqus_string=${disqus_string//\[/\\\[}     # changes all "[" to "\["
disqus_string=${disqus_string//\]/\\\]}     # changes all "]" to "\]"
disqus_string=${disqus_string//\$/\\\$}     # changes all "$" to "\$"
disqus_string=${disqus_string//\./\\\.}     # changes all "." to "\."
disqus_string=${disqus_string//\*/\\\*}     # changes all "*" to "\*"
disqus_string=${disqus_string//\^/\\\^}     # changes all "^" to "\^"
disqus_string=${disqus_string//\//\\\/}     # changes all "/" to "\/"
disqus_string=${disqus_string//\"/\\\"}     # changes all '"' to '\"'

github_ribbon=${github_ribbon//\\/\\\\}     # changes all "\" to "\\"
github_ribbon=${github_ribbon//\[/\\\[}     # changes all "[" to "\["
github_ribbon=${github_ribbon//\]/\\\]}     # changes all "]" to "\]"
github_ribbon=${github_ribbon//\$/\\\$}     # changes all "$" to "\$"
github_ribbon=${github_ribbon//\./\\\.}     # changes all "." to "\."
github_ribbon=${github_ribbon//\*/\\\*}     # changes all "*" to "\*"
github_ribbon=${github_ribbon//\^/\\\^}     # changes all "^" to "\^"
github_ribbon=${github_ribbon//\//\\\/}     # changes all "/" to "\/"
github_ribbon=${github_ribbon//\"/\\\"}     # changes all '"' to '\"'

# start to insert

for html_f in $html_files
do
    # ==== Attaching jf code ====
    if grep -q '^ <script' $html_f; then
        echo skip ${html_f##*/} - already attached the jf code
    else
        echo ----- Attaching jf code to ${html_f##*/} ...
        # insert a new line after </head> tag
        sed -i "/<\/head>/a\ $jf_string" $html_f
    fi
    # ==== Attaching disqus code ====
    if grep -q 'disqus_thread' $html_f; then
        echo skip ${html_f##*/} - already attached the disqus code
    else
        echo ----- Attaching disqus code to ${html_f##*/} ...
        dyn_id=${html_f##*/}
        dyn_id=${dyn_id%%.*}
        unique_disqus_string=${disqus_string//DYNAMIC_ID/$dyn_id}
        sed -i "/<div\ role=\"contentinfo\">/i\ $unique_disqus_string" $html_f
    fi
    # ==== Replacing "View source file" with a github ribbon ====
    if grep -q 'forkme_right_green' $html_f; then
        echo skip ${html_f##*/} - already attached the github ribbon
    else
        if grep -q 'View page source' $html_f; then
            echo ----- Attaching a github ribbon to ${html_f##*/} ...
            sed -i "/View page source/a\ $github_ribbon" $html_f
            sed -i "/View page source/d" $html_f
        else
            echo skip ${html_f##*/} - No "View page source"
        fi
    fi
done

# or     $ find . -type f -exec sed -e 's/cpu/memory/ig' '{}' \;
# see http://blog.miniasp.com/post/2010/12/24/Useful-tool-Find-and-Replace-with-sed-command.aspx
