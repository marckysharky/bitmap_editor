# Bitmap Editor

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

Replay the example:
```bash
./bin/bitmap_editor start -i "I 5 6" -i "L 2 3 A" -i "S" -i "V 2 3 6 W" -i "H 3 5 2 Z" -i "S"
```

## Testing
```bash
bundle install && rspec
```

## Notes
- `BitmapEditor::Image` Class is large, any maybe not readable enough
- `BitmapEditor::Instructions#perform` is maybe too complicated
- Did not apply `rubocop` to the project - should have
