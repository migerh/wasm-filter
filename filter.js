function noiseJs(imageData) {
    const numberOfPoints = 1000,
        { data, width, height } = imageData;

    for (let i = 0; i < numberOfPoints; ++i) {
        const x = Math.random() * width,
            y = Math.random() * height,
            pixelIndex = Math.floor(y * width + x);

        data[pixelIndex * 4 + 0] = 0;
        data[pixelIndex * 4 + 1] = 0;
        data[pixelIndex * 4 + 2] = 0;
        data[pixelIndex * 4 + 3] = 0;
    }

    return data;
}

function clamp(value)
{
    if (value < 0)
    {
        return 0;
    }
    if (value > 255)
    {
        return 255;
    }
    return value;
}

function applyKernel(imageData, bufferOut, x, y, kernel) {
    const {data, width, height} = imageData;
    let sum = 0;
    let kernelIndex = 0;

    for (let i = -1; i <= 1; ++i)
    {
        for (let k = -1; k <= 1; ++k)
        {
            let posX = x + k;
            let posY = y + i;
            if (posX >= 0 && posX < width && posY >= 0 && posY < height)
            {
                let index = posY * width + posX;
                sum += data[index * 4] * kernel[kernelIndex];
            }
            kernelIndex += 1;
        }
    }
    let index = y * width + x;
    let clampedSum = clamp(sum);
    bufferOut[index * 4 + 0] = clampedSum;
    bufferOut[index * 4 + 1] = clampedSum;
    bufferOut[index * 4 + 2] = clampedSum;
    bufferOut[index * 4 + 3] = 255;
}

function outlineJs(imageData) {
    const {width, height} = imageData,
        bufferOut = new Uint8Array(width * height * 4);
    
    for (let y = 0; y < height; ++y) {
        for (let x = 0; x < width; ++x) {
            applyKernel(imageData, bufferOut, x, y, [-1, -1, -1, -1, 8, -1, -1, -1, -1]);
        }
    }

    return bufferOut;
}

function filterWasm(imageData) {
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

function filter(imageData) {
    if (!wasmModule) {
        return outlineJs(imageData);
    }

    return filterWasm(imageData);
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