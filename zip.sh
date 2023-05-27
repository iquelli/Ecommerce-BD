#! /usr/bin/env sh

GROUP=02
FOLDER_NAME=entrega-bd-02-$GROUP

mkdir /tmp/$FOLDER_NAME
cp ./reports/report2.pdf /tmp/$FOLDER_NAME/report.pdf
cp -r ./scripts/*.sql /tmp/$FOLDER_NAME/
cp ./output.txt /tmp/$FOLDER_NAME/

pushd /tmp
zip -r $FOLDER_NAME.zip $FOLDER_NAME
popd

mv /tmp/$FOLDER_NAME.zip .
rm -r /tmp/$FOLDER_NAME
