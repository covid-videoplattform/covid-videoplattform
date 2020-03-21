package main

import (
	"github.com/BurntSushi/toml"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	"log"
	"net/http"
)

var db *gorm.DB
var conf struct {
	Listen     string
	Database   string
	AdminUsers []string `toml:"admin_users"`
}

func main() {
	// read configuration file
	if _, err := toml.DecodeFile("config.toml", &conf); err != nil {
		log.Fatal(err)
	}

	// init database
	var err error
	db, err = gorm.Open("sqlite3", conf.Database)
	if err != nil {
		log.Fatal(err)
	}
	db.AutoMigrate(&Videobridges{})
	db.AutoMigrate(&Staff{})
	db.AutoMigrate(&Patient{})
	db.AutoMigrate(&Appointment{})
	defer db.Close()

	// init key
	initKey()

	// attach handler
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "static/"+r.URL.Path[1:])
	})

	// attach controlller endppints
	registerControllerEndpoints()

	log.Output(0, "Listening on "+conf.Listen)
	log.Fatal(http.ListenAndServe(conf.Listen, nil))
}
