# BitMap Editor

## Running
```bash
./bin/bitmap_editor
```

### Examples

Interactive:
```bash
./bin/bitmap_editor start
```

Interactive, with initial instruction:
```bash
./bin/bitmap_editor start -i "I 2 2"
Starting...
> I 2 2
> S
OO
OO
```

Disable interaction with instructions:
```bash
./bin/bitmap_editor start --no-interaction -i "I 2 2" -i "S" -i "X"
Starting...
> I 2 2
> S
OO
OO
> X
Goodbye!
```

## Testing
```bash
bundle install && rspec
```
