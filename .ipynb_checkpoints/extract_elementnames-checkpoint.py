from pathlib import Path
import os
import csv
from collections import Counter, defaultdict
import itertools
import numpy as np
from bs4 import BeautifulSoup, SoupStrainer, Tag
from xml.etree import ElementTree as etree

path = 'gsa_original'
ext = '**/*.xml'
docTranscripts = [str(p) for p in Path(path).glob(ext) if p.stem != p.parent.stem]


def extract_elementnames(docTranscripts):
    # extracts and counts unique XML elements in 'docTranscipts'
    tagStats = Counter()
    for doc in docTranscripts:
        tree = etree.parse(str(doc))
        tags = tree.findall('.//{http://www.tei-c.org/ns/1.0}sourceDoc//*')
        tagStats.update([tag.tag for tag in tags])
    return tagStats


def write_stats(tagStats,name):
    # writes element count from :func:extract_elementnames() to csv
    w = csv.writer(open(name, "w"))
    for key, val in tagStats.items():
        w.writerow([key, val])


def unused_tags(tagStats):
    # looks for unused elements
    sourceDoc_list = ["interp", 'interpGrp',"span", "spanGrp","certainty", "precision", "respons","binaryObject",\
    "cb", "gap", "gb", "graphic", "index", "lb", "media", "milestone", "note", "pb",\
    'figure',"formula", "notatedMusic","fLib", "fs", "fvLib","alt", "altGrp", "anchor", "join", "joinGrp",\
    "link", "linkGrp", "timeline","incident", "kinesic","pause", "shift", "vocal", "writing", "app", "witDetail",\
    "addSpan", "damageSpan", "delSpan", "fw", "listTranspose", "metamark", "space", "substJoin", "surface", "surfaceGrp"]

    tagshort=[]
    for key, val in tagStats.items():
        tagshort.append(key.split("}")[1])
    return set(sourceDoc_list)-set(tagshort)


def extract_siblings(docTranscripts):
    tagStats = Counter()
    focus = SoupStrainer("sourceDoc")
    for s in docTranscripts:
        with open(s) as fp:
            soup = BeautifulSoup(fp, "xml",parse_only=focus)
            for element in soup.find_all():
                if isinstance(element.next_sibling, Tag) and isinstance(element.previous_sibling, Tag):
                    tagStats.update([element.previous_sibling.name+"_"+element.name+"_"+element.next_sibling.name])
    return tagStats


def extract_neighbours():
    tagStats = Counter()
    for s in docTranscripts:
        print(s)
        with open(s) as fp:
            soup = BeautifulSoup(fp, "xml")
            for element in soup.find_all():
                if isinstance(element.next_element, Tag) and isinstance(element.previous_element, Tag) and isinstance(element, Tag):
                    tagStats.update([element.previous_element.name+"_"+element.name+"_"+element.next_element.name])
    return tagStats


def extract_all_siblings(docTranscripts):
    tagStats = Counter()
    focus = SoupStrainer("sourceDoc")
    siblings = []
    for s in docTranscripts:
        print(s)
        with open(s) as fp:
            soup = BeautifulSoup(fp, "xml",parse_only=focus)
            for element in soup.find_all():
                next_list = [(i.name+"_") for i in element.next_siblings if isinstance(i, Tag)]
                previous_list = [(i.name+"_") for i in element.previous_siblings if isinstance(i, Tag)]
                previous_list.append(element.name+"_")
                all_siblings = "".join(previous_list + next_list)
                siblings.append(all_siblings
        tagStats.update(siblings)
    return tagStats


def clean_all_siblings(docTranscripts):
    all_siblings = extract_all_siblings(docTranscripts)
    new_siblings = {k: v for k, v in all_siblings.items() if "line" not in k}
    new_siblings = {k: v for k, v in new_siblings.items() if len(k.split("_")) > 2}

    by_len = [k.split("_") for k, v in new_siblings.items()]
    by_len = [sorted(t) for t in by_len]
    by_len.sort()
    by_len = list(by_len for by_len, _ in itertools.groupby(by_len))
    return new_siblings, sorted(by_len)

tagStats = extract_elementnames(docTranscripts)
write_stats(tagStats, "tagnames_unique.csv")
unused = unused_tags(tagStats)
siblings = extract_siblings(docTranscripts)
neighbors = extract_neighbours(docTranscripts)
write_stats(siblings, "sibling.csv")
write_stats(neighbors, "neighbors.csv")
new_siblings, len_siblings = clean_all_siblings(docTranscripts)
write_stats(new_siblings, "all_siblings.csv")
with open('siblings_by_len.csv', 'w') as f:
    write = csv.writer(f, delimiter=" ")
    for item in len_siblings:
        write.writerow([item])
