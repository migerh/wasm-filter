unsigned int random(unsigned int max);

const int outline_kernel[10] = {
    -1, -1, -1,
    -1,  8, -1,
    -1, -1, -1,
    1
};

// unused - just forces the compiler to allocate enough memory for the module
unsigned char buffer[640*480*4*6] = {0};


unsigned char clamp(int value, int scale)
{
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

void applyKernel(unsigned char* buffer_in, unsigned char* buffer_out, int x, int y, unsigned int width, unsigned int height, const int kernel[10])
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
        }
    }
}