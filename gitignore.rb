say 'Setting up .gitignore...'

append_file '.gitignore', <<~TXT
  # Ignore .env file containing credentials.
  .env

  # Ignore Mac and Linux file system files
  *.swp
  .DS_Store

  # Editor/IDE
  .vscode/
  .idea/
TXT
