#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# --------------------------------------
# Prompts for configuration preferences
# --------------------------------------

# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi
finished=false

echo

# ----------------------
# Perform Configuration
# ----------------------
echo
echo -e "${GREEN}Configuring your development environment... ${NC}"

echo
echo -e "1/4 ${LCYAN}ESLint & Prettier Installation... ${NC}"
echo
npm install -D eslint prettier eslint-plugin-react-hooks

echo
echo -e "2/4 ${YELLOW}Conforming to Airbnb's JavaScript Style Guide... ${NC}"
echo
npm install -D eslint-config-airbnb eslint-plugin-jsx-a11y eslint-plugin-import eslint-plugin-react

echo
echo -e "3/4 ${LCYAN}Making ESlint and Prettier play nice with each other... ${NC}"
echo "See https://github.com/prettier/eslint-config-prettier for more details."
echo
npm install -D eslint-config-prettier eslint-plugin-prettier

if [ "$skip_eslint_setup" == "true" ]; then
  break
else
  echo
  echo -e "4/4 ${YELLOW}Building your .eslintrc${config_extension} file...${NC}"
  > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

  echo ${config_opening}'
  {
    "env": {
        "browser": true,
        "es2021": true,
        "jest": true
    },
    "extends": [
        "airbnb",
        "prettier",
        "plugin:jsx-a11y/recommended",
        "plugin:react-hooks/recommended",
        "eslint:recommended", 
        "plugin:react/recommended", 
        "plugin:prettier/recommended"
    ],
    "parserOptions": {
        "ecmaFeatures": {
            "jsx": true
        },
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "plugins": [
    "prettier",
    "react",
    "react-hooks"
    ],
    "rules": {
        "react/react-in-jsx-scope": "off",
        "react/jsx-filename-extension": [1, { "extensions": [".js", ".jsx"] }],
        "quotes": [
          2,
        "single",
      {
        "avoidEscape": true,
        "allowTemplateLiterals": true
      }
    }
  }' >> .eslintrc.json
fi

echo
echo -e "${GREEN}Finished setting up!${NC}"
echo
