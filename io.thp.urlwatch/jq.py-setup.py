#!/usr/bin/env python

import os
import subprocess
import tarfile
import shutil
import sysconfig

import requests
from setuptools import setup
from setuptools.command.build_ext import build_ext
from setuptools.extension import Extension

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

jq_extension = Extension(
    "jq",
    sources=["jq.c"],
    extra_link_args=["-lm"],
    extra_objects=[
        os.path.join(os.environ.get("FLATPAK_DEST"), "lib", "libjq.so"),
        os.path.join(os.environ.get("FLATPAK_DEST"), "lib", "libonig.so")
    ],
)

setup(
    name='jq',
    version='1.1.3',
    description='jq is a lightweight and flexible JSON processor.',
    long_description=read("README.rst"),
    author='Michael Williamson',
    url='http://github.com/mwilliamson/jq.py',
    python_requires='>=2.7, !=3.0.*, !=3.1.*, !=3.2.*, !=3.3.*',
    license='BSD 2-Clause',
    ext_modules = [jq_extension],
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
    ],
)

