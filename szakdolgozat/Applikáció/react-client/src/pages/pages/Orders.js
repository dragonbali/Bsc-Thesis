import React, { useEffect, useState } from "react";
import styled from "styled-components/macro";

import Helmet from "react-helmet";

import Moment from "react-moment";
import axios from "axios";
import Swal from "sweetalert2";

import {
  Avatar as MuiAvatar,
  Box,
  Breadcrumbs as MuiBreadcrumbs,
  Button as MuiButton,
  Chip as MuiChip,
  Divider as MuiDivider,
  Grid,
  IconButton,
  Paper as MuiPaper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TablePagination,
  TableRow,
  TableSortLabel,
  TextField as MuiTextField,
  Typography,
  FormControl,
  FormControlLabel,
  FormGroup,
  Switch,
} from "@material-ui/core";

import { green, orange, red } from "@material-ui/core/colors";
import {
  Info as InfoIcon,
  RemoveRedEye as RemoveRedEyeIcon,
} from "@material-ui/icons";

import { spacing } from "@material-ui/system";
import { API_URL } from "../../constants";

const Divider = styled(MuiDivider)(spacing);

const Paper = styled(MuiPaper)(spacing);

const TextField = styled(MuiTextField)(spacing);
const Button = styled(MuiButton)(spacing);

const Chip = styled(MuiChip)`
  ${spacing};
  background: ${(props) => props.done && green[500]};
  background: ${(props) => props.processing && orange[700]};
  background: ${(props) => props.cancelled && red[500]};
  color: ${(props) => props.theme.palette.common.white};
`;

const Customer = styled.div`
  display: flex;
  align-items: center;
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
  { id: "product", alignment: "left", label: "Mester neve" },
  { id: "created_at", alignment: "left", label: "Dátum" },
  { id: "tax_number", alignment: "left", label: "Adószám" },
  { id: "price", alignment: "left", label: "Összeg" },
  { id: "completed", alignment: "left", label: "Fizetési státusz" },
  { id: "payment_method", alignment: "left", label: "Fizetési mód" },
  { id: "actions", alignment: "left", label: "Műveletek" },
  { id: "switch", alignment: "left", label: "Kapcsoló" },
  { id: "regnum", alignment: "left", label: "Nyilvántartási szám" },
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

function EnhancedTable() {
  const [order, setOrder] = React.useState("desc");
  const [orderBy, setOrderBy] = React.useState("created_at");
  const [selected, setSelected] = React.useState([]);
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(10);
  const [reload, setReload] = React.useState(false);
  //api
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [data, setData] = useState([]);
  const [workers, setWorkers] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [billing, workers] = await axios.all([
          axios.get(API_URL + "/billinginfo"),
          axios.get(API_URL + "/workers"),
        ]);
        setData(billing.data);
        setWorkers(workers.data);
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
    const handleRequestSort = (event, property) => {
      const isAsc = orderBy === property && order === "asc";
      setOrder(isAsc ? "desc" : "asc");
      setOrderBy(property);
    };

    const handleSelectAllClick = (event) => {
      if (event.target.checked) {
        const newSelecteds = data.rows.map((n) => n.id);
        setSelected(newSelecteds);
        return;
      }
      setSelected([]);
    };

    const handleChangePage = (event, newPage) => {
      setPage(newPage);
    };

    const handleChangeRowsPerPage = (event) => {
      setRowsPerPage(parseInt(event.target.value, 10));
      setPage(0);
    };

    const emptyRows =
      rowsPerPage -
      Math.min(rowsPerPage, data.rows.length - page * rowsPerPage);

    //SWITCHES

    //erre azert van szukseg mert a worker tablaban ki kell keresni a row.user_id alapjan
    //a tablazat nem .map eli a worker tablat, igy nem tudna megjeleniteni ezt az informaciot, csak igy
    const showInspected = (id) => {
      for (let i = 0; i < workers.rows.length; i++) {
        const element = workers.rows[i];
        if (id === element.user_id) {
          return element.inspected;
        }
        //ha nem letezik a tablaban (bug elkerules)
        if (i === workers.rows.length - 1) {
          return false;
        }
      }
    };

    const handleIsPaid = (event) => {
      //ezeket azert kell letrehozni mert a .then be nem adodik at az event normalisan
      const value = event.target.value;
      const checked = event.target.checked;
      Swal.fire({
        title: "Biztos vagy benne?",
        text: "Megváltoztatod a fizetési státuszát a rendelésnek.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Változtatás",
        cancelButtonText: "Mégse",
      }).then((result) => {
        if (result.isConfirmed) {
          for (let i = 0; i < data.rows.length; i++) {
            const element = data.rows[i];
            if (element.id == value) {
              axios
                .put(`${API_URL}/update-completed?id=${value}`, {
                  completed: checked,
                  items: element.payment_prep_request.items,
                  user_id: element.user_id,
                })
                .then(() => {
                  data.rows[i].completed = checked;
                  reload ? setReload(false) : setReload(true);
                });
            }
          }
        }
      });
    };

    const handleIsInspected = (event) => {
      //ezeket azert kell letrehozni mert a .then be nem adodik at az event normalisan
      const value = event.target.value;
      const checked = event.target.checked;
      axios
        .put(`${API_URL}/update-inspection?id=${value}`, {
          inspected: checked,
        })
        .then(() => {
          for (let i = 0; i < workers.rows.length; i++) {
            const element = workers.rows[i];
            if (element.user_id == value) {
              workers.rows[i].inspected = checked;
            }
          }
          reload ? setReload(false) : setReload(true);
        });
    };

    //eye
    const handleEyeIcon = (id) => {
      for (let i = 0; i < workers.rows.length; i++) {
        const element = workers.rows[i];
        if (element.user_id === id) {
          window.open(`https://mestertkeresek.hu/mesterek/${element.url}`);
        }
      }
    };

    //price
    const showPrice = (id) => {
      for (let i = 0; i < data.rows.length; i++) {
        const element = data.rows[i];
        if (element.id === id) {
          let sum = 0;
          if (element.payment_prep_request.items === null) {
            return sum + " Ft";
          }
          for (let j = 0; j < element.payment_prep_request.items.length; j++) {
            const element2 = element.payment_prep_request.items[j];
            sum += element2.quantity * element2.item_total;
          }
          return sum + " Ft";
        }
      }
    };
    //reg number
    const showRegNumber = (user_id) => {
      for (let i = 0; i < workers.rows.length; i++) {
        const element = workers.rows[i];
        if (element.user_id === user_id) {
          return element.registration_number;
        }
      }
    };

    const handleRegNumberChange = (event, user_id) => {
      for (let i = 0; i < workers.rows.length; i++) {
        const element = workers.rows[i];
        if (element.user_id === user_id) {
          workers.rows[i].registration_number = event.target.value;
          reload ? setReload(false) : setReload(true);
        }
      }
    };

    const handleRegNumberSubmit = (user_id) => {
      let regnum = null;
      for (let i = 0; i < workers.rows.length; i++) {
        const element = workers.rows[i];
        if (element.user_id === user_id) {
          regnum = element.registration_number;
        }
      }

      axios
        .put(`${API_URL}/update-regnumber?id=${user_id}`, {
          registration_number: regnum,
        })
        .then(() => {
          reload ? setReload(false) : setReload(true);
          Swal.fire({
            icon: "success",
            title: "Mentve",
            showConfirmButton: false,
            timer: 1000,
          });
        });
    };

    //avatar
    const avatarColor = (completed, payment_method) => {
      if (completed === true) {
        return "#4caf50";
      }
      if (payment_method === "bank transfer" && completed === false) {
        return "#f57c00";
      }
      if (
        (payment_method === "barion" || payment_method === null) &&
        completed === false
      ) {
        console.log("piros");
        return "#f44336";
      }
    };

    const showMonogram = (name) => {
      return name.substring(1, 0).toUpperCase();
    };

    return (
      <div>
        <Paper>
          <TableContainer>
            <Table
              aria-labelledby="tableTitle"
              size={"medium"}
              aria-label="enhanced table"
            >
              <EnhancedTableHead
                numSelected={selected.length}
                order={order}
                orderBy={orderBy}
                onSelectAllClick={handleSelectAllClick}
                onRequestSort={handleRequestSort}
                rowCount={data.rows.length}
              />
              <TableBody>
                {stableSort(data.rows, getComparator(order, orderBy))
                  .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  .map((row) => {
                    const Avatar = styled(MuiAvatar)`
                      background: ${() =>
                        avatarColor(row.completed, row.payment_method)};
                    `;

                    return (
                      <TableRow>
                        <TableCell align="left">
                          <Customer>
                            <Avatar>
                              {showMonogram(
                                row.payment_prep_request.billing_address.name
                              )}
                            </Avatar>
                            <Box ml={3}>
                              {row.payment_prep_request.billing_address.name}
                              <br />
                              {row.payment_prep_request.payer_email}
                              <br />#{row.order_number}
                            </Box>
                          </Customer>
                        </TableCell>
                        <TableCell align="left">
                          <Moment format="YYYY/MM/DD">{row.created_at}</Moment>
                        </TableCell>
                        <TableCell align="left">
                          {row.payment_prep_request.billing_address.tax_number}
                        </TableCell>
                        <TableCell align="left">{showPrice(row.id)}</TableCell>
                        <TableCell>
                          {row.completed === true && (
                            <Chip
                              size="small"
                              mr={1}
                              mb={1}
                              label="Elkészült"
                              done
                            />
                          )}
                          {row.payment_method === "bank transfer" &&
                            row.completed === false && (
                              <Chip
                                size="small"
                                mr={1}
                                mb={1}
                                label="Feldolgozás alatt"
                                processing
                              />
                            )}
                          {(row.payment_method === "barion" ||
                            row.payment_method === null) &&
                            row.completed === false && (
                              <Chip
                                size="small"
                                mr={1}
                                mb={1}
                                label="Félbehagyott"
                                cancelled
                              />
                            )}
                        </TableCell>
                        <TableCell align="left">{row.payment_method}</TableCell>
                        <TableCell padding="none" align="left">
                          <Box mr={2}>
                            <IconButton aria-label="info">
                              <InfoIcon />
                            </IconButton>
                            <IconButton
                              aria-label="details"
                              onClick={() => {
                                handleEyeIcon(row.user_id);
                              }}
                            >
                              <RemoveRedEyeIcon />
                            </IconButton>
                          </Box>
                        </TableCell>
                        <TableCell align="left">
                          <FormControl component="fieldset">
                            <FormGroup>
                              <FormControlLabel
                                control={
                                  <Switch
                                    checked={row.completed}
                                    onChange={() => {
                                      if (
                                        row.payment_method == "bank transfer"
                                      ) {
                                        handleIsPaid(event);
                                      } else {
                                        Swal.fire({
                                          icon: "info",
                                          title:
                                            "Kártyás fizetést nem tudsz módosítani",
                                          showConfirmButton: false,
                                          timer: 1800,
                                        });
                                      }
                                    }}
                                    value={row.id}
                                  />
                                }
                                label="Fizetve"
                              />
                              <FormControlLabel
                                control={
                                  <Switch
                                    checked={showInspected(row.user_id)}
                                    onChange={handleIsInspected}
                                    value={row.user_id}
                                  />
                                }
                                label="Ellenőrizve"
                              />
                            </FormGroup>
                            {"user_id: " + row.user_id}
                          </FormControl>
                        </TableCell>
                        <TableCell align="left">
                          <Grid item md={6}>
                            <TextField
                              name="registration_number"
                              label="Nyilv. szám"
                              value={showRegNumber(row.user_id)}
                              onChange={(event) => {
                                handleRegNumberChange(event, row.user_id);
                              }}
                              variant="outlined"
                              autoComplete="off"
                              my={2}
                            />
                            <Button
                              type="submit"
                              variant="contained"
                              color="primary"
                              onClick={() => {
                                handleRegNumberSubmit(row.user_id);
                              }}
                            >
                              Mentés
                            </Button>
                          </Grid>
                        </TableCell>
                      </TableRow>
                    );
                  })}
                {emptyRows > 0 && (
                  <TableRow style={{ height: 53 * emptyRows }}>
                    <TableCell colSpan={8} />
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </TableContainer>
          <TablePagination
            rowsPerPageOptions={[5, 10, 25]}
            component="div"
            count={data.rows.length}
            rowsPerPage={rowsPerPage}
            page={page}
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
          />
        </Paper>
      </div>
    );
  }
}

function OrderList() {
  return (
    <React.Fragment>
      <Helmet title="Megrendelések" />

      <Grid justify="space-between" container spacing={24}>
        <Grid item>
          <Typography variant="h3" gutterBottom display="inline">
            Megrendelések
          </Typography>
        </Grid>
      </Grid>

      <Divider my={6} />

      <Grid container spacing={6}>
        <Grid item xs={12}>
          <EnhancedTable />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

export default OrderList;
