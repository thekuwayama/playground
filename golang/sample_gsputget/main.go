package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"

	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

const (
	CRED_PATH = ".google_application_credentials"
	// gs://${bucketName}/${object}
	BUCKET_NAME = "rdap2_result_48"
	OBJECT      = "sample.txt"
)

func main() {
	homodir := os.Getenv("HOME")
	credPath := homodir + "/" + CRED_PATH
	// fmt.Println(credPath)
	ctx := context.Background()
	err := putObject(ctx, BUCKET_NAME, OBJECT, "ok", credPath)
	if err != nil {
		panic(err)
	}

	data, err := getObject(ctx, BUCKET_NAME, OBJECT, credPath)
	if err != nil {
		panic(err)
	}

	fmt.Println(string(data))
}

func putObject(ctx context.Context, bkt, obj, content, credPath string) error {
	cli, err := storage.NewClient(ctx, option.WithCredentialsFile(credPath))
	if err != nil {
		return err
	}
	defer cli.Close()

	w := cli.Bucket(bkt).Object(obj).NewWriter(ctx)
	w.ContentType = "text/plain"
	_, err = w.Write([]byte(content))
	if err != nil {
		w.Close()
		return err
	}

	err = w.Close()
	if err != nil {
		return err
	}

	return nil
}

func getObject(ctx context.Context, bkt, obj, credPath string) ([]byte, error) {
	cli, err := storage.NewClient(ctx, option.WithCredentialsFile(credPath))
	if err != nil {
		return nil, err
	}
	defer cli.Close()

	r, err := cli.Bucket(bkt).Object(obj).NewReader(ctx)
	if err != nil {
		return nil, err
	}
	defer r.Close()

	data, err := ioutil.ReadAll(r)
	if err != nil {
		return nil, err
	}

	return data, nil
}
