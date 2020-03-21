package main

import (
	"time"
)

type Videobridges struct {
	ID   uint
	Name string
}

type Staff struct {
	ID   uint
	Name string
}

type Patient struct {
	ID uint
}

type Appointment struct {
	ID       uint
	Patient  Patient
	Staff    Staff
	datetime time.Time
	URL      string
}
