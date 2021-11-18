import React from "react";

import styled from "styled-components/macro";

import Moment from "react-moment";
import axios from "axios";
import Swal from "sweetalert2";

import {
  Avatar as MuiAvatar,
  Box,
  Chip as MuiChip,
  IconButton,
  TableBody,
  TableCell,
  TableRow,
  FormControl,
  FormControlLabel,
  FormGroup,
  Switch,
} from "@material-ui/core";

import { green, orange, red } from "@material-ui/core/colors";
import { RemoveRedEye as RemoveRedEyeIcon } from "@material-ui/icons";

import { spacing } from "@material-ui/system";
import { API_URL } from "../../constants";

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

function EnhancedTableBody(props) {
  const { data, workers, order, orderBy, page, rowsPerPage } = props;
  const [reload, setReload] = React.useState(false);

  const emptyRows =
    rowsPerPage - Math.min(rowsPerPage, data.rows.length - page * rowsPerPage);

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
              .put(`${API_URL}/workers/update/completed/${value}`, {
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
      .put(`${API_URL}/workers/update/inspection/${value}`, {
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
    <TableBody>
      {stableSort(data.rows, getComparator(order, orderBy))
        .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
        .map((row) => {
          const Avatar = styled(MuiAvatar)`
            background: ${() => avatarColor(row.completed, row.payment_method)};
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
              <TableCell align="left">
                {row.completed === true && (
                  <Chip size="small" mr={1} mb={1} label="Elkészült" done />
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
              <TableCell align="center">
                <IconButton
                  aria-label="details"
                  onClick={() => {
                    handleEyeIcon(row.user_id);
                  }}
                >
                  <RemoveRedEyeIcon />
                </IconButton>
              </TableCell>
              <TableCell align="left">
                <FormControl component="fieldset">
                  <FormGroup>
                    <FormControlLabel
                      control={
                        <Switch
                          checked={row.completed}
                          onChange={() => {
                            if (row.payment_method == "bank transfer") {
                              handleIsPaid(event);
                            } else {
                              Swal.fire({
                                icon: "info",
                                title: "Kártyás fizetést nem tudsz módosítani",
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
                </FormControl>
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
  );
}

export default EnhancedTableBody;
