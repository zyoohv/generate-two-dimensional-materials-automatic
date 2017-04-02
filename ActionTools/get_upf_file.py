import os


def search_upf_identity(atom_set, upf_middle, upf_list_path):
    db = {}
    with open(upf_list_path, 'r') as fin:
        for line in fin:
            item = [str(i) for i in line.strip().split(' ') if i]
            db[item[0]] = set(item[1:])
    if atom_set.intersection(db[upf_middle]) == atom_set:
        return True
    else:
        return False


def search_upf_file(atom_set, upf_list_path):

    with open(upf_list_path, 'r') as fin:
        for line in fin:
            item = [str(i) for i in line.strip().split(' ') if i]
            if atom_set.intersection(set(item[1:])) == atom_set:
                return item[0]
    return None
