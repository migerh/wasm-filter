function filter(imageData) {
    const bufferPointerIn = 1024,
        {data, width, height} = imageData,
        bufferIn = new Uint8Array(wasmModule.memory.buffer, bufferPointerIn, width * height * 4),
        bufferPointerOut = 2048 + width * height * 4,
        bufferOut = new Uint8Array(wasmModule.memory.buffer, bufferPointerOut, width * height * 4);

    bufferIn.set(data);
    wasmModule.outline_c(bufferPointerIn, bufferPointerOut, width, height);
    data.set(bufferOut);
    return data;
}

function renderSource(source, destination) {
    const context = destination.getContext('2d');
    context.drawImage(source, 0, 0, destination.width, destination.height);

    const imageData = context.getImageData(0, 0, destination.width, destination.height);
    imageData.data.set(filter(imageData));
    context.putImageData(imageData, 0, 0);

    requestAnimationFrame(_ => renderSource(source, destination));
}

async function loadWasm() {
    const response = await fetch(`filter.wasm`),
        wasmFile = await response.arrayBuffer(),
        compiledModule = await WebAssembly.compile(wasmFile),
        wasmModule = await WebAssembly.instantiate(compiledModule, {
            env: {
                random: max => Math.floor(Math.random() * max),
                logInt: console.log
            }
        });

    return wasmModule.exports;
}

async function main() {
    const video = document.createElement('video'),
        stream = await navigator.mediaDevices.getUserMedia({ audio: false, video: true });

    wasmModule = await loadWasm();

    video.setAttribute(`width`, 640);
    video.setAttribute(`height`, 480);
    video.setAttribute(`src`, URL.createObjectURL(stream));
    video.play();

    const image = document.querySelector('#image');
    requestAnimationFrame(_ => renderSource(video, image));
}

let wasmModule;
main()
    .catch(console.error);