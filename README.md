# wasm-filter

A simple example that shows how to pass image data to wasm and back to js and render it in a canvas.


## build

You need

* [LLVM/clang compiled with wasm support](https://gist.github.com/yurydelendik/4eeff8248aeb14ce763e)
* [binaryen](https://github.com/WebAssembly/binaryen)

If you have the tools compiled and ready you can compile the filter.c with

```
$ clang filter.c -o filter.s -S -Os --std=c11 -Os --target=wasm32
$ s2wasm filter.s -o filter.wast
$ wasm-as filter.wast
```

The `-o` parameter defines the output. `-S` tells clang to only run preprocessing and compilation steps but no linking. `-Os` is the optimization flag (makes the generated wasm smaller) and `--std=c11` defines the C standard used. `s2wasm` transforms LLVM output to WebAssembly's wast format, which is turned into the binary wasm format with `wasm-as`.

## run

Just run a local webserver, e.g.

```
$ npm install -g pushstate-server
$ pushstate-server .
```

and open `filter.html` in one of the [browsers that support wasm](http://caniuse.com/#search=webassembly).
