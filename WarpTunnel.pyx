
@cython.binding(False)
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cpdef tunnel_modeling(int screen_width, int screen_height):

    cdef int [:] distances = numpy.empty((screen_width * screen_height * 4), int32)
    cdef int [:] angles    = numpy.empty((screen_width * screen_height * 4), int32)
    cdef int [:] shades    = numpy.empty((screen_width * screen_height * 4), int32)

    surface = pygame.image.load("Assets\\space.jpg").convert()

    cdef int s_width  = 512
    cdef int s_height = 512
    surface = pygame.transform.smoothscale(surface, (s_width, s_height))
    cdef unsigned char [::1] scr_data = surface.get_buffer()

    cdef  int x, y, i = 0

    for y in range(0, screen_height * 2):
        sqy = pow(y - screen_height, 2)
        for x in range(0, screen_width * 2):
            sqx = pow(x - screen_width, 2)
            if (sqx + sqy) == 0:
                distances[i] = 1
            else:
                distances[i] = <int>(floor(32 * <float>s_height / <float>sqrt(sqx + sqy))) % s_height
            angles[i]    = <int>round(<float>s_width * atan2(y - screen_height, x - screen_width) / (<float>M_PI))
            shades[i]    = <int>min(sqrt(sqx + sqy)*10, 255)
            i = i + 1

    return distances, angles, shades, scr_data

@cython.binding(False)
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cpdef tunnel_render(int t,
                    int screen_width,
                    int screen_height,
                    int [::1] distances,
                    int [::1] angles,
                    int [::1] shades,
                    unsigned char [::1] scr_data):
    cdef:
        int s_width = 512
        int s_height = 512
        unsigned char [::1] dest_array = numpy.zeros((screen_width * screen_height * 4), uint8)
        float timer = t / 1000.0
        int shiftx = <int>floor(s_width * timer)
        int shifty = <int>floor(s_height * 0.25 * timer)
        int centerx = <int>(screen_width / 2.0 + floor((screen_width / 4.0) * sin(timer / 4.0)))
        int centery = <int>(screen_height / 2.0 + floor((screen_height / 4.0) * sin(timer / 2.0)))
        int stride = screen_width * 2
        int destOfs = 0
        int srcOfs
        int u, v, x, y
        int pixOfs, shade

    with nogil:
        for y in range(0,  screen_height):
            srcOfs = y * stride + centerx + centery * stride
            for x in range(0, screen_width):
                u = (distances[srcOfs] + shiftx) & 0xff
                v = (angles[srcOfs] + shifty) & 0xff
                while v < 0:
                  v = v + s_height

                shade = <int>(shades[srcOfs] / 255.0)

                pixOfs = (u + (v << 9)) << 3
                dest_array[destOfs    ] = scr_data[pixOfs + 2] * shade
                dest_array[destOfs + 1] = scr_data[pixOfs + 1] * shade
                dest_array[destOfs + 2] = scr_data[pixOfs + 0] * shade
                dest_array[destOfs + 3] = 255 # scr_data[pixOfs + 4] * shade

                destOfs = destOfs + 4
                pixOfs  = pixOfs + 4
                srcOfs  = srcOfs + 1

    return pygame.image.frombuffer(dest_array, (screen_width, screen_height), "RGBA")
