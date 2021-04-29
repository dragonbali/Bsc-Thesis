import React, { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../../constants";

import styled from "styled-components/macro";
import { useLocation } from "react-router-dom";

import Swal from "sweetalert2";
import moment from "moment";

import {
  Button as MuiButton,
  Card as MuiCard,
  CardContent,
  Grid,
  TextField as MuiTextField,
  Typography,
  Switch,
} from "@material-ui/core";

import { spacing } from "@material-ui/system";

const Card = styled(MuiCard)(spacing);

const TextField = styled(MuiTextField)(spacing);

const Button = styled(MuiButton)(spacing);

function EditJob() {
  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }

  let query = useQuery();
  const jobId = query.get("id");
  //sates
  const [reload, setReload] = React.useState(false);
  const [date, setDate] = useState(moment(new Date()).format("YYYY-MM-DD"));
  //api
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [job, setJob] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [job] = await axios.all([
          axios.get(API_URL + "/job?id=" + jobId),
        ]);
        setJob(job.data.rows[0]);
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
    const handleInputChange = (event) => {
      job[event.target.name] = event.target.value;
      reload ? setReload(false) : setReload(true);
    };
    const handleSwitchChange = (event) => {
      job[event.target.name] = event.target.checked;
      reload ? setReload(false) : setReload(true);
    };

    const handleSubmitButton = (ThisJob) => {
      axios.put(`${API_URL}/update-job?id=${ThisJob.id}`, ThisJob).then(() => {
        Swal.fire({
          icon: "success",
          title: "Mentve",
          showConfirmButton: false,
          timer: 1000,
        });
      });
      reload ? setReload(false) : setReload(true);
    };

    const handleDate = (dateParam) => {
      return dateParam.split("T")[0];
    };

    const handleChangeDate = (e) => {
      job.due_date = new Date(e.target.value).toISOString();
      reload ? setReload(false) : setReload(true);
    };

    return (
      <Card mb={6}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Job
          </Typography>
          <Typography variant="body2" gutterBottom>
            Itt tudod módosítani a job adatait.
          </Typography>
          <Grid container spacing={4}>
            <Grid item md={3}>
              <TextField
                name="owner_email"
                label="Email"
                value={job.owner_email}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                type="email"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={1}>
              <TextField
                name="category"
                label="Kategória"
                value={job.category}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                type="number"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={4}>
              <TextField
                name="title"
                label="Cím"
                value={job.title}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                my={2}
              />
            </Grid>
            <Grid item md={1}>
              <TextField
                name="profession"
                label="Szakma"
                value={job.profession}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                type="number"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={3}>
              <TextField
                name="phone"
                label="Telefon"
                value={job.phone}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={4}>
            <Grid item md={1}>
              <TextField
                name="price_min"
                label="Ár min."
                value={job.price_min}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                type="number"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={1}>
              <TextField
                name="price_max"
                label="Ár max."
                value={job.price_max}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                type="number"
                variant="outlined"
                my={2}
              />
            </Grid>
            <Grid item md={1}>
              <TextField
                name="location_id"
                label="Hely ID"
                value={job.location_id}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                type="number"
                variant="outlined"
                my={2}
              />
            </Grid>
            <Grid item md={2}>
              <TextField
                name="date"
                id="date"
                label="Esedékesség dátum"
                type="date"
                variant="outlined"
                value={handleDate(job.due_date)}
                InputLabelProps={{
                  shrink: true,
                }}
                onChange={handleChangeDate}
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={12}>
            <Grid item md={2}>
              <span>Sürgős</span>
              <Switch
                name="urgent"
                checked={job.urgent}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
          </Grid>
          <TextField
            name="description"
            label="Leírás"
            value={job.description}
            fullWidth
            onChange={(event) => {
              handleInputChange(event);
            }}
            multiline
            variant="outlined"
            my={2}
          />
          <Button
            type="submit"
            variant="contained"
            color="primary"
            onClick={() => {
              handleSubmitButton(job);
            }}
            mt={3}
          >
            Mentés
          </Button>
        </CardContent>
      </Card>
    );
  }
}

export default EditJob;
