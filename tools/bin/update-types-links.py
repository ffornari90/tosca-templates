import argparse
import re
import shutil

version_pattern = re.compile(r'^\d+(\.\d+)*$')

def is_version(string):
    return bool(version_pattern.match(string))

parser = argparse.ArgumentParser()
parser.add_argument("version", help="new final version")
parser.add_argument("input_file", help="path to the input YAML file")
args = parser.parse_args()

input_f = args.input_file
output_f = "{}.bck".format(input_f)

# Compile the regular expression patterns
pattern_url = re.compile("https://baltig.infn.it/infn-cloud/tosca-types/(-/)?raw/[^/]+/")
pattern_version = re.compile("template_version: .*")

version = "v{}".format(args.version) if is_version(args.version) else args.version

with open(input_f, "r") as input_file, open(output_f, "w") as output_file:
    for line in input_file:
        line = pattern_url.sub("https://baltig.infn.it/infn-cloud/tosca-types/raw/{}/".format(version), line)
        if (is_version(args.version)):
          line = pattern_version.sub("template_version: {}".format(args.version), line)

        # Write the modified line to the output file
        output_file.write(line)

shutil.move(output_f, input_f)

