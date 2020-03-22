package main

import (
	"encoding/json"
	"net/http"
)

func registerControllerEndpoints() {
	controllerPrefix := "/controller/"
	endpoints := map[string]func(http.ResponseWriter, *http.Request){
		"getToken": getToken,
		"getStaff": getStaff,
	}
	for k, v := range endpoints {
		http.HandleFunc(controllerPrefix+k, v)
	}
	keys := make([]string, 0, len(endpoints))
	for k := range endpoints {
		keys = append(keys, k)
	}
	http.HandleFunc(controllerPrefix, func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(struct{ Endpoints []string }{keys})
	})
}

// Helper functions

func returnError(w http.ResponseWriter, status int, text string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(struct{ Error string }{text})
}

func returnErrorExample(w http.ResponseWriter, status int, text string, example interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(struct {
		Error   string
		Example interface{}
	}{text, example})
}

func getJson(r *http.Request, target interface{}) error {
	return json.NewDecoder(r.Body).Decode(target)
}

// controller endpoints

func getToken(w http.ResponseWriter, r *http.Request) {
	credentials := struct {
		Username string
		Password string
	}{}
	if err := getJson(r, &credentials); err != nil {
		returnErrorExample(w, http.StatusBadRequest, "Invalid JSON in body of request", credentials)
		return
	}

	token, err := generateToken(credentials.Username, credentials.Password)
	if err != nil {
		returnError(w, http.StatusUnprocessableEntity, "Wrong credentials")
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(struct{ Token string }{token})
}

func getStaff(w http.ResponseWriter, r *http.Request) {
	// defined required arguments (received via HTTP POST/GET
	args := struct {
		Token string
	}{}

	// parsing arguments to args
	if err := getJson(r, &args); err != nil {
		returnErrorExample(w, http.StatusBadRequest, "Invalid JSON in body of request", args)
		return
	}

	// check authentification token
	if !checkToken(args.Token) {
		returnError(w, http.StatusUnprocessableEntity, "Wrong Token")
		return
	}

	// actually fetch the data & write it back
	var members []Staff
	db.Find(&members)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(members)
}
