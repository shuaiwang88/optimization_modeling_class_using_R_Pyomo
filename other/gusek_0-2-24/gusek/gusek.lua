
function winex_context(toreg)
	local basediraux = props['SciteDefaultHome']..'\\Gusek.exe'
	basediraux = '@="\\"'..string.gsub(basediraux, '\\', '\\\\')..'\\" \\"%1\\""'
	local tempfile = 'gskext.reg'
	local greg = io.open(tempfile, 'wb')
	greg:write ('Windows Registry Editor Version 5.00\n')
	if (string.find(toreg,'1')) then
		--~ to add Gusek to context menu in windows explorer
		greg:write ('\n[HKEY_CLASSES_ROOT\\*\\shell\\opengusek]')
		greg:write ('\n@="Open in &Gusek"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\*\\shell\\opengusek\\command]')
		greg:write ('\n'..basediraux)
	elseif (string.find(toreg,'2')) then
		--~ to remove context menu
		greg:write ('\n[-HKEY_CLASSES_ROOT\\*\\shell\\opengusek]')
	elseif (string.find(toreg,'3')) then
		--~ to associate GMPL files to Gusek
		greg:write ('\n[-HKEY_CLASSES_ROOT\\.mod]')
		greg:write ('\n[HKEY_CLASSES_ROOT\\.mod]')
		greg:write ('\n@="gusek_file"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\.dat]')
		greg:write ('\n@="gusek_file"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\.out]')
		greg:write ('\n@="gusek_file"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\.lp]')
		greg:write ('\n@="gusek_file"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\.mps]')
		greg:write ('\n@="gusek_file"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\gusek_file]')
		greg:write ('\n@=""')
		greg:write ('\n[-HKEY_CLASSES_ROOT\\gusek_file\\DefaultIcon]')
		greg:write ('\n[HKEY_CLASSES_ROOT\\gusek_file\\shell]')
		greg:write ('\n@="opengusek"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\gusek_file\\shell\\opengusek]')
		greg:write ('\n@="Open in &Gusek"')
		greg:write ('\n[HKEY_CLASSES_ROOT\\gusek_file\\shell\\opengusek\\command]')
		greg:write ('\n'..basediraux)
	end
	greg:write ('\n')
	greg:close()
	os.run('regedit /s '..tempfile,1,true)
	os.remove(tempfile)
end

function move_ren_file()
	local nomeum = props['FilePath']
	scite.Perform('saveas:')
	if (not (props['FilePath'] == nomeum)) then os.remove(nomeum) end
end


function gusek_openout()
	if (props['ckmn2']=='1') then
		props['doout']=''
		props['opnout']=''
		props['ckmn2']=0
	else
		props['doout']='-o "$(FileName).out"'
		props['opnout']='$(FileName).out'
		props['ckmn2']=1
	end
end

function gusek_openbnd()
	if (props['ckmn9']=='1') then
		props['dobnd']=''
		props['opnbnd']=''
		props['ckmn9']=0
	else
		props['dobnd']='--ranges "$(FileName)_sens.out"'
		props['opnbnd']='$(FileName)_sens.out'
		props['ckmn9']=1
	end
end

function gusek_milpopt()
	if (props['ckmn3']=='1') then
		props['milporiginal']=props['1'];
		props['1']=''
		props['ckmn3']=0
	else
		props['1']=props['milporiginal']
		props['ckmn3']=1
	end
	scite.UpdateStatusBar(true)
end

function gusek_datparam()
	if (props['ckmn4']=='1') then
		props['2']=''
		props['3']=''
		props['2name']=''
		props['3name']=''
		props['ckmn4']=0
	else
		props['2']='-d "$(FileName).dat"'
		props['ckmn4']=1
	end
	scite.UpdateStatusBar(true)
end

function gusek_setdat()
	props['2']=''
	props['2']='-d "'..props['FilePath']..'"'
	props['2name']=' -d '..props['FileNameExt']
	props['ckmn4']=1
	scite.UpdateStatusBar(true)
end

function gusek_adddat()
	props['3']=props['3']..'-d "'..props['FilePath']..'" '
	props['3name']=props['3name']..' -d '..props['FileNameExt']
	props['ckmn4']=1
	scite.UpdateStatusBar(true)
end

function gusek_clrdat()
	props['3']=''
	props['3name']=''
	if (props['2']=='') then
		props['ckmn4']=0
	end
	scite.UpdateStatusBar(true)
end

function gusek_fixmps()
	if (props['ckmn8']=='1') then
		props['mpstype']='mps'
		props['ckmn8']=0
	else
		props['mpstype']='freemps'
		props['ckmn8']=1
	end
end
