package main

import (
	"crypto/rand"
	"github.com/dgrijalva/jwt-go"
	"log"
	"time"
)

var key []byte

type CustomClaims struct {
	Username string
	jwt.StandardClaims
}

type AuthError struct {
	Reason string
}

func (error *AuthError) Error() string {
	return error.Reason
}

func initKey() {
	length := 4096
	key = make([]byte, length)
	_, err := rand.Read(key)
	if err != nil {
		log.Fatal(err)
	}
}

func isAdmin(username string) bool {
	userIsAdmin := false
	for _, admin := range conf.AdminUsers {
		if username == admin {
			userIsAdmin = true
			break
		}
	}
	return userIsAdmin
}

func checkToken(tokenString string) bool {
	// Parse the token
	token, err := jwt.ParseWithClaims(tokenString, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
		return key, nil
	})

	if err != nil {
		return false
	}

	// Validate the token and return the custom claims
	if claims, ok := token.Claims.(*CustomClaims); ok && token.Valid {
		return isAdmin(claims.Username)
	} else {
		return false
	}
}

func generateToken(username string, password string) (string, error) {
	if !isAdmin(username) {
		return "", &AuthError{"Wrong credentials provided"}
	}

	expireToken := time.Now().Add(time.Hour * 72).Unix()
	claims := CustomClaims{
		username,
		jwt.StandardClaims{
			ExpiresAt: expireToken,
			Issuer:    "covid-videoplatform",
		},
	}

	// Create token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Sign token and return
	return token.SignedString(key)
}
