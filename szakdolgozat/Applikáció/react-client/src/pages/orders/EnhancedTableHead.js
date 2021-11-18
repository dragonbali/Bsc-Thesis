import React from "react";

import {
  TableCell,
  TableHead,
  TableRow,
  TableSortLabel,
} from "@material-ui/core";

const headCells = [
  { id: "product", alignment: "left", label: "Mester neve" },
  { id: "created_at", alignment: "left", label: "Dátum" },
  { id: "tax_number", alignment: "left", label: "Adószám" },
  { id: "price", alignment: "left", label: "Összeg" },
  { id: "completed", alignment: "left", label: "Fizetési státusz" },
  { id: "payment_method", alignment: "left", label: "Fizetési mód" },
  { id: "actions", alignment: "center", label: "Műveletek" },
  { id: "switch", alignment: "left", label: "Kapcsolók" },
];

function EnhancedTableHead(props) {
  const { order, orderBy, onRequestSort } = props;
  const createSortHandler = (property) => (event) => {
    onRequestSort(event, property);
  };

  return (
    <TableHead>
      <TableRow>
        {headCells.map((headCell) => (
          <TableCell
            key={headCell.id}
            align={headCell.alignment}
            padding={headCell.disablePadding ? "none" : "default"}
            sortDirection={orderBy === headCell.id ? order : false}
          >
            <TableSortLabel
              active={orderBy === headCell.id}
              direction={orderBy === headCell.id ? order : "asc"}
              onClick={createSortHandler(headCell.id)}
            >
              {headCell.label}
            </TableSortLabel>
          </TableCell>
        ))}
      </TableRow>
    </TableHead>
  );
}

export default EnhancedTableHead;
