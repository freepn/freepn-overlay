python-overlay
==============

.. image:: https://travis-ci.org/freepn/python-overlay.svg?branch=master
    :target: https://travis-ci.org/freepn/python-overlay

FreePN portage overlay for (extra) Python packages.

Quick and dirty layman install::

  $ layman -f -a python-overlay -o https://raw.github.com/freepn/python-overlay/master/layman.xml

Install the overlay without layman
----------------------------------

Create a repos.conf file for the overlay and place the file in the
``/etc/portage/repos.conf`` directory.  Run::

  # nano -w /etc/portage/repos.conf/python-overlay.conf

and add the following content to the new file::

  [python-overlay]

  # Various python ebuilds for FreePN
  # Maintainer: nerdboy (nerdboy@gentoo.org)

  location = /var/db/repos/python-overlay
  sync-type = git
  sync-uri = https://github.com/freepn/python-overlay.git
  priority = 50
  auto-sync = yes

Adjust the path in the ``location`` field as needed, then save and exit nano.

Run the following command to sync the repo::

  # emaint sync --repo python-overlay

