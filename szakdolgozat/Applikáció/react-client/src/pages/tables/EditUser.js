import React, { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../../constants";

import styled from "styled-components/macro";
import { useLocation } from "react-router-dom";

import Swal from "sweetalert2";

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

function EditUser() {
  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }

  let query = useQuery();
  const userId = query.get("id");
  //sates
  const [reload, setReload] = React.useState(false);
  //api
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [user, setuser] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [user] = await axios.all([
          axios.get(API_URL + "/user?id=" + userId),
        ]);
        setuser(user.data.rows[0]);
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
      user[event.target.name] = event.target.value;
      reload ? setReload(false) : setReload(true);
    };
    const handleSwitchChange = (event) => {
      user[event.target.name] = event.target.checked;
      reload ? setReload(false) : setReload(true);
    };

    const handleSubmitButton = (ThisUser) => {
      axios
        .put(`${API_URL}/update-user?id=${ThisUser.id}`, ThisUser)
        .then(() => {
          Swal.fire({
            icon: "success",
            title: "Mentve",
            showConfirmButton: false,
            timer: 1000,
          });
        });
      reload ? setReload(false) : setReload(true);
    };

    return (
      <Card mb={6}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            User
          </Typography>
          <Typography variant="body2" gutterBottom>
            Itt tudod módosítani a User adatait.
          </Typography>
          <Grid container spacing={4}>
            <Grid item md={4}>
              <TextField
                name="name"
                label="Név"
                value={user.name}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={2}>
              <TextField
                name="phone"
                label="Telefonszám"
                value={user.phone}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={2}>
              <TextField
                name="email"
                label="Email"
                value={user.email}
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
            <Grid item md={4}>
              <TextField
                name="profile_pic"
                label="Profil kép URL"
                value={user.profile_pic}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={12}>
            <Grid item md={2}>
              <span>Email megerősítve</span>
              <Switch
                name="email_verified"
                checked={user.email_verified}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
          </Grid>
          <Button
            type="submit"
            variant="contained"
            color="primary"
            onClick={() => {
              handleSubmitButton(user);
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

export default EditUser;
