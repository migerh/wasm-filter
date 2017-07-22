unsigned int random(unsigned int max);
void logInt(int);

const int outline_kernel[10] = {
    -1, -1, -1,
    -1,  8, -1,
    -1, -1, -1,
    1
};

const int sobel_left_kernel[10] = {
    -1, 0, 1,
    -2, 0, 2,
    -1, 0, 1,
    1
};

const int scharr_kernel[10] = {
    -3, 0, 3,
    -10, 0, 10,
    -3, 0, 3,
    1
};

const int prewitt_kernel[10] = {
    -1, 0, 1,
    -1, 0, 1,
    -1, 0, 1,
    1
};

const int gauss_kernel[10] = {
    1, 2, 1,
    2, 4, 2,
    1, 2, 1,
    16
};

const int id_kernel[10] = {
    0, 0, 0,
    0, 1, 0,
    0, 0, 0,
    1
};


// unused - just forces the compiler to allocate enough memory for the module
unsigned char buffer[640*480*4*6] = {0};


void noise_c(unsigned char* buffer_in, unsigned char* buffer_out, unsigned int width, unsigned int height)
{
    const unsigned int bytesPerPixel = 4;
    unsigned int numberOfOverwrittenPixels = 1000;
    const unsigned int numberOfPixels = width * height;

    for (unsigned int i = 0; i < numberOfPixels; ++i)
    {
        buffer_out[i] = buffer_in[i];
    }

    for (unsigned int i = 0; i < numberOfOverwrittenPixels; ++i)
    {
        unsigned int x = random(width);
        unsigned int y = random(height);
        unsigned int index = y * width + x;

        buffer[index * bytesPerPixel + 0] = 255;
        buffer[index * bytesPerPixel + 1] = 0;
        buffer[index * bytesPerPixel + 2] = 0;
        buffer[index * bytesPerPixel + 3] = 255;
    }
}

void red_c(unsigned char* buffer_in, unsigned char* buffer_out, unsigned int width, unsigned int height)
{
    const unsigned int bytesPerPixel = 4;
    const unsigned int numberOfPixels = width * height;

    for (unsigned int i = 0; i < numberOfPixels; ++i)
    {
        unsigned char red = buffer_in[i * bytesPerPixel];
        buffer_out[i * bytesPerPixel + 0] = red;
        buffer_out[i * bytesPerPixel + 1] = red;
        buffer_out[i * bytesPerPixel + 2] = red;
        buffer_out[i * bytesPerPixel + 3] = 255;
    }
}

unsigned char clamp(int value, int scale)
{
    // value += 255;
    value /= scale;
    if (value < 0)
    {
        return 0;
    }
    if (value > 255)
    {
        return 255;
    }
    return (unsigned char)(value);
}

void applyKernel(unsigned char* buffer_in, unsigned char* buffer_out, int x, int y, unsigned int width, unsigned int height, int kernel[10])
{
    int sum = 0;
    int kernelIndex = 0;

    for (int i = -1; i <= 1; ++i)
    {
        for (int k = -1; k <= 1; ++k)
        {
            int posX = x + k;
            int posY = y + i;
            if (posX >= 0 && posX < width && posY >= 0 && posY < height)
            {
                int index = posY * width + posX;
                sum += (int)buffer_in[index * 4] * (int)kernel[kernelIndex];
            }
            kernelIndex += 1;
        }
    }
    int index = y * width + x;
    unsigned char clampedSum = clamp(sum, kernel[9]);
    buffer_out[index * 4 + 0] = clampedSum;
    buffer_out[index * 4 + 1] = clampedSum;
    buffer_out[index * 4 + 2] = clampedSum;
    buffer_out[index * 4 + 3] = 255;
}

void outline_c(unsigned char* buffer_in, unsigned char* buffer_out, unsigned int width, unsigned int height)
{
    for (int y = 0; y < (int)height; ++y)
    {
        for (int x = 0; x < (int)width; ++x)
        {
            applyKernel(buffer_in, buffer_out, x, y, width, height, outline_kernel);
            //applyKernel(buffer_out, buffer_in, x, y, width, height, gauss_kernel);
        }
    }
}

void threshold_c(unsigned char* buffer_in, unsigned char* buffer_out, unsigned int width, unsigned int height, unsigned char threshold)
{
    for (int y = 0; y < (int)height; ++y)
    {
        for (int x = 0; x < (int)width; ++x)
        {
            unsigned char value = 0;
            unsigned int index = y * width + x;
            if (buffer_in[index * 4] > threshold)
            {
                value = 255;
            }

            buffer_out[index * 4 + 0] = value;
            buffer_out[index * 4 + 1] = value;
            buffer_out[index * 4 + 2] = value;
            buffer_out[index * 4 + 3] = 255;
        }
    }
}