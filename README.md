# vue3-pinia-clean
A bash script to help you getting started with Vite.js + Vue3.js + Pinia. 

## !!! DANGER !!! 
DO NOT RUN THIS ON AN EXISTING PROJECT. THIS IS MEANT TO BE USED ON A NEW PROJECT. THE SCRIPT WILL OVERWRITE main.js, App.vue.
I'm not responsible if you're overwriting your existing project.

## To make it easier I suggest you to put the script into your bashrc

### Add the script to the bashrc file:

- Open the terminal and type `nano ~/.bashrc` to open the bashrc file in the nano editor.
- Add the following line at the end of the file: `alias vue3-pinia-clean="sh path/to/vue3-pinia-clean.sh"` (replace "path/to/vue3-pinia-clean.sh" with the actual path to the script file)
- Save and close the file by pressing CTRL + X, then Y, and finally Enter.
- Remember to `chmod +x vue3-pinia-clean.sh`
- Open a new terminal or type `source ~/.bashrc` to reload the bashrc file.
        
## Usage
- Create a new vite.js vue3 project: `npm create vite@latest` (be sure to select Vue, and Javascript)
- enter the directory
- run the script by typing `vue3-pinia-clean`
- run `npm install && npm install pinia`

The script will then delete all unnecessary files inside the vue3 project folders and install Pinia store in the project.

Your project is ready to go: you can check that everything is working with `npm run dev`

You should see a page with this text:
```
Here we go!
store msg: Hello from Pinia!
store getter reversed(): !ainiP morf olleH
```
First line is a simple text written inside the main `HomePage.vue` component

Second line is taking the `msg` from the pinia store

Third line is a simple getter `reversed()` from the pinia store.


    
