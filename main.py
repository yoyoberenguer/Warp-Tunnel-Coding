
import pygame

SCREEN = pygame.display.set_mode((800, 800))
SCREENRECT = SCREEN.get_rect()

width, height = 800, 800

from Shader import tunnel_modeling, tunnel_render

distances, angles, shades, scr_data = tunnel_modeling(width, height)


if __name__ == '__main__':
    frame = 0
    CLOCK = pygame.time.Clock()
    GAME = True
    while GAME:

        pygame.event.pump()
        for event in pygame.event.get():

            keys = pygame.key.get_pressed()

            if keys[pygame.K_ESCAPE]:
                GAME = False
                pygame.image.save(SCREEN, "screenshot1.png")
                break
            if event.type == pygame.MOUSEMOTION:
                MOUSE_POS = event.pos

        surface_ = tunnel_render(
            frame * 25,
            width,
            height,
            distances,
            angles,
            shades,
            scr_data
        )

        SCREEN.blit(surface_, (0, 0))

        pygame.display.flip()
        CLOCK.tick(8000)
        print(CLOCK.get_fps())

        frame += 1

