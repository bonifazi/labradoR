library(hexSticker)
plot(
  sticker(
    # subplot = "C:/Users/bonif002/Documents/logos_labrador/95b8cd65-e2bb-40e9-942f-a7cf54759811-removebg-preview.png",
    subplot = "C:/Users/bonif002/Documents/logos_labrador/doggo.png",
    # SUBPLOT PARAMS
    s_x = 1,
    s_y = 1.15,
    s_width = 1,
    s_height = 1,
    asp = 0.5, # aspect-ratio
    dpi = 500,
    #
    # PKG TITLE PARAMS
    package = "labradoR",
    # package = "",
    p_size = 32,
    p_color = "white",
    p_x = 1,
    p_y = 0.44,

    # EXAGON PARAMS
    # h_fill = "#00203F", # color to fill hexagon
    h_fill = "#00223C", # color to fill hexagon
    h_color = "#3ADFC4", # color for hexagon border
    # h_size = 5,

    # spotlight = T,
    filename = "man/figures/logo_labradoR.png",

    # URL PARAMS
    url = "github.com/bonifazi/labradoR",
    # bottom right corner position
    # u_x = 1,
    # u_y = 0.08,
    # u_angle = 30,
    u_color = "white",
    u_family = "Aller_Rg",
    u_size = 6,
    # mid-right position
    u_x = 1.80,
    u_y = 0.55,
    u_angle = 90,

    white_around_sticker = T # cut the sub_plot extra cols

  )
)

# darker versions of color
# https://www.color-hex.com/color/023788

# palette:
# https://www.reddit.com/media?url=https%3A%2F%2Fi.redd.it%2Fsynthwave-color-palette-this-work-of-art-is-not-mine-i-v0-3fwmgurggi4a1.png%3Fs%3D3601cadc83ea0c70375056d99135b9e5eed4f0d1
