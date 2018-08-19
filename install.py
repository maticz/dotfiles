import os
import pathlib
import shutil
import subprocess

packages = [
    'vim-X11',
    'i3',
    'i3status',
    'dmenu',
    'i3lock',
    'dunst',
    'xbacklight',
    'feh',
    'network-manager-applet',
]

def install_packages():
    print('About to install Fedora packages.')
    params = ['sudo', 'dnf', '-y', 'install']
    params.extend(packages)
    result = subprocess.run(params)
    print('\n')

    print('About to install vim-plug.')
    home = str(pathlib.Path.home())
    vim_autoload_path = os.path.join(home, '.vim/autoload/plug.vim')
    params = ['curl', '-fLo', vim_autoload_path, '--create-dirs', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim']
    result = subprocess.run(params)

def create_links(root_dir):
    if not root_dir.endswith('/'):
        root_dir = root_dir + '/'

    home = str(pathlib.Path.home()) + '/tttt'

    for dirpath, dirnames, filenames in os.walk(root_dir):
        relative_dir = dirpath.replace(root_dir, '')
        for f in filenames:
            src = os.path.join(dirpath, f)
            dst_dir = os.path.join(home, relative_dir)
            dst = os.path.join(dst_dir, f)

            print('About to create a new link.')
            print('Source: {}'.format(src))
            print('Destination: {}'.format(dst))

            os.makedirs(dst_dir, exist_ok=True)

            if os.path.exists(dst):
                if os.path.realpath(dst) == src:
                    print('Link already exists and points to correct source, skipping.')
                    print('----')
                    continue

                print('Destination file exists. Creating backup for it.')
                shutil.move(dst, dst+'_bak')

            os.symlink(src, dst)
            print('Link created: {}.'.format(dst))
            print('----')


if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.realpath(__file__))
    script_home = os.path.join(script_dir, 'home')

    print('About to install packages')
    install_packages()
    print('Packages installed\n\n')

    print('About to create links')
    create_links(script_home)
    print('Links created')
    print('Done')
