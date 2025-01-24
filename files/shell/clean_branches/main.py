#!/home/mikhail-hyde/.local/share/virtualenvs/clean_branches-anhLjqMu/bin/python3

import subprocess
from prompt_toolkit import Application
from prompt_toolkit.layout import Layout
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.widgets import CheckboxList, Box, Button, Label
from prompt_toolkit.shortcuts import message_dialog
from prompt_toolkit.layout.containers import HSplit, VSplit


def get_git_branches():
    try:
        result = subprocess.run(
            ["git", "branch", "--list"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True
        )
        branches = result.stdout.strip().split("\n")
        return [branch.strip("* ").strip() for branch in branches]
    except subprocess.CalledProcessError as e:
        print(f"Error fetching branches: {e.stderr}")
        return []


def delete_git_branch(branch: str) -> None:
    try:
        subprocess.run(
            ["git", "branch", "-D", branch],
            check=True,
        )
        print(f"Branch '{branch}' deleted successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to delete branch '{branch}': {e.stderr}")


def checkbox_dialog(text, values):
    checkbox_list = CheckboxList(values)

    def on_ok_clicked():
        selected = checkbox_list.current_values
        if not selected:
            message_dialog("No branches selected", "Please select branches to delete.").run()
        else:
            app.exit(result=selected)

    def on_cancel_clicked():
        app.exit(result=None)

    ok_button = Button(text="OK", handler=on_ok_clicked)
    cancel_button = Button(text="Cancel", handler=on_cancel_clicked)

    bindings = KeyBindings()

    @bindings.add('left')
    def _(_):
        app.layout.focus_previous()

    @bindings.add('right')
    def _(_):
        app.layout.focus_next()

    dialog_body = HSplit([
        Label(text=text),
        checkbox_list,
        VSplit([ok_button, cancel_button], padding=3)
    ])

    layout = Layout(container=Box(body=dialog_body, style="class:dialog.body"))
    app = Application(layout=layout, key_bindings=bindings, full_screen=True)

    result = app.run()
    return result


def main():
    branches = get_git_branches()
    if not branches:
        print("No branches available to delete.")
        return

    selected_branches = checkbox_dialog(
        text="Select the branches you want to delete:",
        values=[(branch, branch) for branch in branches]
    )

    if selected_branches:
        print("You have selected:")
        for branch in selected_branches:
            print(branch)
        confirm = input("Are you sure you want to delete the selected branches? (y/n): ")
        if confirm.lower() == 'y':
            for branch in selected_branches:
                delete_git_branch(branch)
        else:
            print("Deletion cancelled.")
    else:
        print("No branches selected.")


if __name__ == "__main__":
    main()
