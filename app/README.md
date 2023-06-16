# Use Docker

Start the containers with

```bash
sudo docker-compose up -d
```

Stop the containers with

```bash
sudo docker-compose down
```

Do the following to run the sql files automatically

```bash
chmod 744 ./run.sh
sudo ./run.sh
```

The webserver (for the .cgi files) will be available at https://localhost:5001/.

Database credentials are

- Host: `db` inside the containers, `localhost:5432` outside
- Username: `postgres`
- Password: `postgres`

To use the postgres console through the docker console, run

```bash
sudo docker-compose exec db psql postgres postgres
```

Data for the database is stored at `./data`, which can be deleted to reset the database.
