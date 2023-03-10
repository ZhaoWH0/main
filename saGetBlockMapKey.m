function mapkey = saGetBlockMapKey(blkhdl)
if isstr(blkhdl) 
    if ~isempty(strfind(blkhdl, '/'))
        libname = strtok(blkhdl, '/');
        if ~bdIsLoaded(libname)
            if exist(libname, 'file')==4
                load_system(libname);
            else %if given string but cannot find corresponding MDL file
                mapkey = []; % return mapkey as empty
                return;
            end
        end
        blkhdl = get_param(blkhdl, 'Handle');
    else
        mapkey = blkhdl;
        return;
    end
end
msktyp = get_param(blkhdl,'MaskType');
blktyp = get_param(blkhdl,'BlockType');
if ~isempty(msktyp)
    mapkey = msktyp;
else
    if ismember(blktyp, {'S-Function','SubSystem'})
        [issf, sftyp] = saIsStateflow(blkhdl);
        if issf % bug fix for version after 2012b wherein "Stateflow" is not MaskType property anymore
            mapkey = sftyp;
        else
            refblk = get_param(blkhdl, 'ReferenceBlock');
            ancblk = get_param(blkhdl, 'AncestorBlock');
            if ~isempty(refblk)
                mapkey = refblk;
            elseif ~isempty(ancblk)
                mapkey = ancblk;
                %         elseif
            else
                mapkey = blktyp;
            end
        end
    else
        mapkey = blktyp;
    end
end
end