#!/bin/bash

### Example Usage
# ~/yadm/scripts/gen-long-cert.sh

# CERT_NAME=uptimekuma
# DOMAIN_URL=status.int.mishracloud.com
# DURATION_YRS=3


generate_cert_inputs() {
  if [ -z "$CERT_NAME" ]; then
    read -p "Please enter the CERT_NAME: " CERT_NAME
  fi

  if [ -z "$DOMAIN_URL" ]; then
    read -p "Please enter the DOMAIN_URL: " DOMAIN_URL
  fi

  if [ -z "$DURATION_YRS" ]; then
    read -p "Please enter the duration in YRS [default: 3]: " DURATION_YRS
    if [ -z "$DURATION_YRS" ]; then
      DURATION_YRS=3
    fi
  fi
  # Convert years to hours
  duration_hours=$((DURATION_YRS * 365 * 24))

  read -p "Do you want to add additional SANs? (y/N): " add_sans

  SANS=()

  if [[ "$add_sans" =~ ^[Yy]$ ]]; then
    while true; do
      read -p "Enter additional SAN (leave empty to finish): " san
      if [ -z "$san" ]; then
        break
      fi
      SANS+=("$san")
    done
  fi

  SAN_ARGS=()
  for san in "${SANS[@]}"; do
    SAN_ARGS+=(--san "$san")
  done
  
  OUTPUT_DIR=/home/pranav/docker/mishracloud/step-ca/long-certificates/$CERT_NAME

  echo "Current output directory is: $OUTPUT_DIR"
  read -p "Is this output directory acceptable? (Y/n): " dir_ok
  if [[ "$dir_ok" =~ ^[Nn]$ ]]; then
    read -p "Please enter a new output directory: " OUTPUT_DIR
  fi

}




generate_certs() {
  mkdir -p "$OUTPUT_DIR"
  step ca certificate "$DOMAIN_URL" "$OUTPUT_DIR/$CERT_NAME.crt" "$OUTPUT_DIR/$CERT_NAME.key" --not-after="${duration_hours}h" --san "$DOMAIN_URL" "${SAN_ARGS[@]}"
  
  cd "$OUTPUT_DIR"
  ls -lah
}

echo "=================================================================="
echo "Generating Certificates using Step CA"
echo "=================================================================="
echo

# Gather inputs from the user variables are not set
generate_cert_inputs

echo
echo 
echo "=================================================================="
echo "Preparing to generate a certificate with the following details:"
echo "Certificate files to be generated: $CERT_NAME.crt and $CERT_NAME.key"
echo "Output directory: $OUTPUT_DIR"
echo "Domain URL and first SAN will be set to: $DOMAIN_URL"
echo "Validity: $DURATION_YRS years ($duration_hours hours)"
echo "Additional SANs: ${SANS[*]:-None}"
echo "=================================================================="
echo


# Generate the certificates if the user agrees
echo -e "\e[32mWould you like to proceed with certificate generation? (Y/n):\e[0m"
read proceed


if [[ -z "$proceed" || "$proceed" =~ ^[Yy]$ ]]; then
  generate_certs
else
  echo "Certificate generation aborted."
  exit 0
fi

# Display the generated certificate details
echo
echo "=================================================================="
echo -e "\e[32mCertificate generation completed successfully!\e[0m"
echo "Certificate files are located in: $OUTPUT_DIR"
echo
cat $OUTPUT_DIR/$CERT_NAME.crt | step certificate inspect --short
echo
echo "=================================================================="
