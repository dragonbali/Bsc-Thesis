import React, { useEffect, useState } from "react";

import EnhancedTableHead from "./EnhancedTableHead";

import styled from "styled-components/macro";

import axios from "axios";

import {
  Paper as MuiPaper,
  Table,
  TableContainer,
  TablePagination,
} from "@material-ui/core";

import { spacing } from "@material-ui/system";
import { API_URL } from "../../constants";
import EnhancedTableBody from "./EnhancedTableBody";

const Paper = styled(MuiPaper)(spacing);

function EnhancedTable() {
  const [order, setOrder] = React.useState("desc");
  const [orderBy, setOrderBy] = React.useState("created_at");
  const [selected, setSelected] = React.useState([]);
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(10);
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
          axios.get(API_URL + "/info/billings"),
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
              <EnhancedTableBody
                data={data}
                workers={workers}
                order={order}
                orderBy={orderBy}
                page={page}
                rowsPerPage={rowsPerPage}
              />
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

export default EnhancedTable;
