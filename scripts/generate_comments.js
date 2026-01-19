const fs = require('fs');

const markdownFilePath = 'docs/diccionario_datos.md';
const outputSqlFilePath = 'scripts/comments.sql';
const schema = 'muses_dev';

try {
  const markdownContent = fs.readFileSync(markdownFilePath, 'utf8');
  const lines = markdownContent.split('\n');

  let comments = [];
  let currentTable = '';
  let inTable = false;

  for (const line of lines) {
    // Detectar una nueva tabla
    const tableMatch = line.match(/^### \*\*(.+?)\*\*/);
    if (tableMatch) {
      currentTable = tableMatch[1].trim();
      inTable = false; // Reset in case we were in a table block

      // La línea siguiente a la cabecera de la tabla es la descripción
      const tableDescriptionIndex = lines.indexOf(line) + 1;
      const tableDescription = lines[tableDescriptionIndex].trim();

      if (tableDescription && !tableDescription.startsWith('|')) {
        comments.push(`COMMENT ON TABLE ${schema}.${currentTable} IS '${tableDescription.replace(/'/g, "''")}';`);
      }
      continue;
    }

    // Detectar el inicio de una tabla de columnas
    if (line.startsWith('| Nombre de la Columna')) {
      inTable = true;
      continue;
    }

    // Si estamos en una tabla, procesar las filas
    if (inTable && line.startsWith('| `')) {
      const parts = line.split('|').map(p => p.trim());
      if (parts.length >= 5) {
        const columnName = parts[1].replace(/`/g, '').trim();
        const description = parts[4].trim();

        if (columnName && description) {
          comments.push(`COMMENT ON COLUMN ${schema}.${currentTable}.${columnName} IS '${description.replace(/'/g, "''")}';`);
        }
      }
    }
  }

  fs.writeFileSync(outputSqlFilePath, comments.join('\n\n'));
  console.log(`Script de comentarios generado exitosamente en: ${outputSqlFilePath}`);

} catch (error) {
  console.error('Ocurrió un error al generar el script de comentarios:', error);
}
