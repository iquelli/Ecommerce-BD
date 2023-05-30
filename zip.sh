#! /usr/bin/env sh

GROUP=02
FOLDER_NAME=entrega-bd-03-$GROUP

mkdir /tmp/$FOLDER_NAME
cp ./reports/report3.pdf /tmp/$FOLDER_NAME/$GROUP-relatorio.pdf
cp ./scripts/populate.sql /tmp/$FOLDER_NAME
cp ./scripts/ICs.sql /tmp/$FOLDER_NAME
cp ./scripts/queries.sql /tmp/$FOLDER_NAME
cp ./scripts/view.sql /tmp/$FOLDER_NAME
cp ./scripts/analytics.sql /tmp/$FOLDER_NAME
cp ./scripts/schema.sql /tmp/$FOLDER_NAME
cp -r ./web /tmp/$FOLDER_NAME

pushd /tmp
zip -r $FOLDER_NAME.zip $FOLDER_NAME
popd

mv /tmp/$FOLDER_NAME.zip .
rm -r /tmp/$FOLDER_NAME
