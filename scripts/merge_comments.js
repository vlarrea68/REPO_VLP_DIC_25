const fs = require('fs');
const path = require('path');

const ddlFilePath = path.join(__dirname, '..', 'bd', 'ddl_sep_muses_v01.sql');
const commentsFilePath = path.join(__dirname, 'comments.sql');
const outputFilePath = ddlFilePath; // Overwrite the original file

try {
    // Read the original DDL file and the comments file
    const ddlContent = fs.readFileSync(ddlFilePath, 'utf8');
    const commentsContent = fs.readFileSync(commentsFilePath, 'utf8');

    // Split DDL into lines
    const ddlLines = ddlContent.split('\n');

    // Filter out old comment lines and empty comment blocks
    const cleanedLines = [];
    let isInsideEmptyCommentBlock = false;
    for (let i = 0; i < ddlLines.length; i++) {
        const line = ddlLines[i];
        if (line.trim().startsWith('-- Name:') && line.includes('Type: COMMENT;')) {
            // Check if the next line is just the comment terminator '--'
            if (i + 1 < ddlLines.length && ddlLines[i+1].trim() === '--') {
                 // This is the start of an empty comment block, skip this line and the next
                 i++;
                 continue;
            }
        }
        if (line.trim().startsWith('COMMENT ON')) {
            continue; // Skip existing comment statements
        }
        cleanedLines.push(line);
    }

    const cleanedDdl = cleanedLines.join('\n');

    // Find the insertion point
    const insertionMarker = '-- Completed on';
    const markerIndex = cleanedDdl.lastIndexOf(insertionMarker);

    if (markerIndex === -1) {
        throw new Error(`Could not find the insertion marker: "${insertionMarker}"`);
    }

    // Split the DDL content at the insertion point
    const ddlBeforeMarker = cleanedDdl.substring(0, markerIndex);
    const ddlAfterMarker = cleanedDdl.substring(markerIndex);

    // Construct the new DDL content
    const newDdlContent =
`${ddlBeforeMarker}
-- =============================================================
-- Comentarios de Tablas y Columnas (Generados Automáticamente)
-- =============================================================

${commentsContent}

${ddlAfterMarker}`;

    // Write the new content back to the DDL file
    fs.writeFileSync(outputFilePath, newDdlContent, 'utf8');
    console.log(`Successfully merged comments into ${outputFilePath}`);

} catch (error) {
    console.error('An error occurred:', error);
    process.exit(1);
}
