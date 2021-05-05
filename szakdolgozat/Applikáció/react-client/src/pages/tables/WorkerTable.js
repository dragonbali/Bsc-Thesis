import React, { useEffect, useState } from "react";
import styled from "styled-components/macro";

import Helmet from "react-helmet";

import axios from "axios";
import { API_URL } from "../../constants";
import Moment from "react-moment";
import { ExportToCsv } from "export-to-csv";

import {
  Checkbox,
  Grid,
  IconButton,
  Breadcrumbs as MuiBreadcrumbs,
  Divider as MuiDivider,
  Paper as MuiPaper,
  Table,
  TableBody,
  TableContainer,
  TableCell,
  TableHead,
  TablePagination,
  TableRow,
  TableSortLabel,
  Toolbar,
  Tooltip,
  Typography,
  FormControlLabel,
  Switch,
  Box,
} from "@material-ui/core";

import {
  ImportExport as ImportExport,
  FilterList as FilterListIcon,
  Info as InfoIcon,
  Edit as EditIcon,
  RemoveRedEye as RemoveRedEyeIcon,
} from "@material-ui/icons";

import { spacing } from "@material-ui/system";

const Divider = styled(MuiDivider)(spacing);

const Paper = styled(MuiPaper)(spacing);

const Spacer = styled.div`
  flex: 1 1 100%;
`;

function descendingComparator(a, b, orderBy) {
  if (b[orderBy] < a[orderBy]) {
    return -1;
  }
  if (b[orderBy] > a[orderBy]) {
    return 1;
  }
  return 0;
}

function getComparator(order, orderBy) {
  return order === "desc"
    ? (a, b) => descendingComparator(a, b, orderBy)
    : (a, b) => -descendingComparator(a, b, orderBy);
}

function stableSort(array, comparator) {
  const stabilizedThis = array.map((el, index) => [el, index]);
  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0]);
    if (order !== 0) return order;
    return a[1] - b[1];
  });
  return stabilizedThis.map((el) => el[0]);
}

const headCells = [
  {
    id: "name",
    numeric: false,
    disablePadding: true,
    label: "Név",
  },
  { id: "joined", numeric: true, disablePadding: false, label: "Dátum" },
  { id: "phone", numeric: true, disablePadding: false, label: "Telefonszám" },
  { id: "email", numeric: true, disablePadding: false, label: "E-mail" },
  {
    id: "location",
    numeric: true,
    disablePadding: false,
    label: "Elhelyezkedés",
  },
  {
    id: "operations",
    numeric: true,
    disablePadding: false,
    label: "Műveletek",
  },
];

function EnhancedTableHead(props) {
  const {
    onSelectAllClick,
    order,
    orderBy,
    numSelected,
    rowCount,
    onRequestSort,
  } = props;
  const createSortHandler = (property) => (event) => {
    onRequestSort(event, property);
  };

  return (
    <TableHead>
      <TableRow>
        <TableCell padding="checkbox">
          <Checkbox
            indeterminate={numSelected > 0 && numSelected < rowCount}
            checked={rowCount > 0 && numSelected === rowCount}
            onChange={onSelectAllClick}
            inputProps={{ "aria-label": "select all" }}
          />
        </TableCell>
        {headCells.map((headCell) => (
          <TableCell
            key={headCell.id}
            align={headCell.numeric ? "right" : "left"}
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

let EnhancedTableToolbar = (props) => {
  const numSelected = props.numSelected.length;
  //csv
  const options = {
    fieldSeparator: ",",
    quoteStrings: '"',
    decimalSeparator: ".",
    showLabels: true,
    showTitle: false,
    title: "",
    useTextFile: false,
    useBom: true,
    useKeysAsHeaders: true,
  };
  //export
  let selectedWorkers = [];
  const handleExport = () => {
    axios
      .get(`${API_URL}/workers`)
      .then(function (response) {
        // handle success
        for (let i = 0; i < response.data.rows.length; i++) {
          const element = response.data.rows[i];
          for (let j = 0; j < props.numSelected.length; j++) {
            const element2 = props.numSelected[j];
            if (element2 === element.id) {
              selectedWorkers.push(element);
            }
          }
        }
        const csvExporter = new ExportToCsv(options);
        csvExporter.generateCsv(selectedWorkers);
      })
      .catch(function (error) {
        // handle error
        console.log(error);
      });
  };
  return (
    <Toolbar>
      <div>
        {numSelected > 0 ? (
          <Typography color="inherit" variant="subtitle1">
            {numSelected} kiválasztva
          </Typography>
        ) : (
          <Typography variant="h6" id="tableTitle">
            Workers
          </Typography>
        )}
      </div>
      <Spacer />
      <div>
        {numSelected > 0 ? (
          <Tooltip title="Export">
            <IconButton
              aria-label="Export"
              onClick={() => {
                handleExport();
              }}
            >
              <ImportExport />
            </IconButton>
          </Tooltip>
        ) : (
          <Tooltip title="Export">
            <IconButton aria-label="Export">
              <FilterListIcon />
            </IconButton>
          </Tooltip>
        )}
      </div>
    </Toolbar>
  );
};

function EnhancedTable() {
  const [order, setOrder] = React.useState("desc");
  const [orderBy, setOrderBy] = React.useState("joined");
  const [selected, setSelected] = React.useState([]);
  const [page, setPage] = React.useState(0);
  const [dense, setDense] = React.useState(false);
  const [rowsPerPage, setRowsPerPage] = React.useState(10);

  const handleRequestSort = (event, property) => {
    const isAsc = orderBy === property && order === "asc";
    setOrder(isAsc ? "desc" : "asc");
    setOrderBy(property);
  };

  const handleClick = (event, id) => {
    const selectedIndex = selected.indexOf(id);
    let newSelected = [];

    if (selectedIndex === -1) {
      newSelected = newSelected.concat(selected, id);
    } else if (selectedIndex === 0) {
      newSelected = newSelected.concat(selected.slice(1));
    } else if (selectedIndex === selected.length - 1) {
      newSelected = newSelected.concat(selected.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelected = newSelected.concat(
        selected.slice(0, selectedIndex),
        selected.slice(selectedIndex + 1)
      );
    }

    setSelected(newSelected);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleChangeDense = (event) => {
    setDense(event.target.checked);
  };

  const isSelected = (id) => selected.indexOf(id) !== -1;
  //API
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [data, setData] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [workers] = await axios.all([axios.get(API_URL + "/workers")]);
        setData(workers.data);
      } catch (error) {
        setError(error);
      }
      setIsLoaded(true);
    };
    fetchData();
  }, []);
  if (error) {
    return <div>Error: {error.message}</div>;
  } else if (!isLoaded) {
    return <div>Loading...</div>;
  } else {
    const rows = data.rows;
    const emptyRows =
      rowsPerPage - Math.min(rowsPerPage, rows.length - page * rowsPerPage);
    const handleSelectAllClick = (event) => {
      if (event.target.checked) {
        const newSelecteds = rows.map((n) => n.id);
        setSelected(newSelecteds);
        return;
      }
      setSelected([]);
    };

    //eye
    const handleEyeIcon = (id) => {
      for (let i = 0; i < rows.length; i++) {
        const element = rows[i];
        if (element.user_id === id) {
          window.open(`https://mestertkeresek.hu/mesterek/${element.url}`);
        }
      }
    };
    //edit
    const handleInfoIcon = (id) => {
      window.open(`/workers/${id}`);
    };
    return (
      <div>
        <Paper>
          <EnhancedTableToolbar numSelected={selected} />
          <TableContainer>
            <Table
              aria-labelledby="tableTitle"
              size={dense ? "small" : "medium"}
              aria-label="enhanced table"
            >
              <EnhancedTableHead
                numSelected={selected.length}
                order={order}
                orderBy={orderBy}
                onSelectAllClick={handleSelectAllClick}
                onRequestSort={handleRequestSort}
                rowCount={rows.length}
              />
              <TableBody>
                {stableSort(rows, getComparator(order, orderBy))
                  .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  .map((row, index) => {
                    const isItemSelected = isSelected(row.id);
                    const labelId = `enhanced-table-checkbox-${index}`;

                    return (
                      <TableRow
                        hover
                        role="checkbox"
                        aria-checked={isItemSelected}
                        tabIndex={-1}
                        key={row.id}
                        selected={isItemSelected}
                      >
                        <TableCell padding="checkbox">
                          <Checkbox
                            onClick={(event) => handleClick(event, row.id)}
                            checked={isItemSelected}
                            inputProps={{ "aria-labelledby": labelId }}
                          />
                        </TableCell>
                        <TableCell
                          component="th"
                          id={labelId}
                          scope="row"
                          padding="none"
                        >
                          {row.name}
                        </TableCell>
                        <TableCell align="right">
                          <Moment format="YYYY/MM/DD">{row.joined}</Moment>
                        </TableCell>
                        <TableCell align="right">{row.phone}</TableCell>
                        <TableCell align="right">{row.email}</TableCell>
                        <TableCell align="right">{row.location}</TableCell>
                        <TableCell align="right">
                          <IconButton
                            aria-label="page"
                            onClick={() => {
                              handleEyeIcon(row.user_id);
                            }}
                          >
                            <RemoveRedEyeIcon />
                          </IconButton>
                          <IconButton
                            aria-label="edit"
                            onClick={() => {
                              handleInfoIcon(row.id);
                            }}
                          >
                            <EditIcon />
                          </IconButton>
                        </TableCell>
                      </TableRow>
                    );
                  })}
                {emptyRows > 0 && (
                  <TableRow style={{ height: (dense ? 33 : 53) * emptyRows }}>
                    <TableCell colSpan={6} />
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </TableContainer>
          <TablePagination
            rowsPerPageOptions={[5, 10, 25]}
            component="div"
            count={rows.length}
            rowsPerPage={rowsPerPage}
            page={page}
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
          />
        </Paper>
        <FormControlLabel
          control={<Switch checked={dense} onChange={handleChangeDense} />}
          label="Sűrű nézet"
        />
      </div>
    );
  }
}
function WorkerTable() {
  return (
    <React.Fragment>
      <Helmet title="Worker Table" />
      <Typography variant="h3" gutterBottom display="inline">
        Worker Tábla
      </Typography>

      <Divider my={6} />

      <Grid container spacing={6}>
        <Grid item xs={12}>
          <EnhancedTable />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

export default WorkerTable;
