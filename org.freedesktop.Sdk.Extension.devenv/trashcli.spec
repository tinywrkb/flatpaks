# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


# trash analysis
trash_a = Analysis(
    ['trash'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# trash-empty analysis
trash_empty_a = Analysis(
    ['trash-empty'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# trash-list analysis
trash_list_a = Analysis(
    ['trash-list'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# trash-put analysis
trash_put_a = Analysis(
    ['trash-put'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# trash-restore analysis
trash_restore_a = Analysis(
    ['trash-restore'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# trash-rm analysis
trash_rm_a = Analysis(
    ['trash-rm'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

MERGE( (trash_a, 'trash', 'trash'), (trash_empty_a, 'trash_empty', 'trash_empty'), (trash_list_a, 'trash_list', 'trash_list'), (trash_put_a, 'trash_put', 'trash_put'), (trash_restore_a, 'trash_restore', 'trash_restore'), (trash_rm_a, 'trash_rm', 'trash_rm'))

pyz = PYZ(trash_a.pure, trash_a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    trash_a.scripts,
    [],
    exclude_binaries=True,
    name='trash',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    trash_a.binaries,
    trash_a.zipfiles,
    trash_a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='trash',
)

pyz = PYZ(trash_empty_a.pure, trash_empty_a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    trash_empty_a.scripts,
    [],
    exclude_binaries=True,
    name='trash-empty',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    trash_empty_a.binaries,
    trash_empty_a.zipfiles,
    trash_empty_a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='trash-empty',
)

pyz = PYZ(trash_list_a.pure, trash_list_a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    trash_list_a.scripts,
    [],
    exclude_binaries=True,
    name='trash-list',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    trash_list_a.binaries,
    trash_list_a.zipfiles,
    trash_list_a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='trash-list',
)

pyz = PYZ(trash_put_a.pure, trash_put_a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    trash_put_a.scripts,
    [],
    exclude_binaries=True,
    name='trash-put',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    trash_put_a.binaries,
    trash_put_a.zipfiles,
    trash_put_a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='trash-put',
)

pyz = PYZ(trash_restore_a.pure, trash_restore_a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    trash_restore_a.scripts,
    [],
    exclude_binaries=True,
    name='trash-restore',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    trash_restore_a.binaries,
    trash_restore_a.zipfiles,
    trash_restore_a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='trash-restore',
)

pyz = PYZ(trash_rm_a.pure, trash_rm_a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    trash_rm_a.scripts,
    [],
    exclude_binaries=True,
    name='trash-rm',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    trash_rm_a.binaries,
    trash_rm_a.zipfiles,
    trash_rm_a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='trash-rm',
)
