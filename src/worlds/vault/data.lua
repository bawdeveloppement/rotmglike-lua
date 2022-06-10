return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.7.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 8,
  tileheight = 8,
  nextlayerid = 3,
  nextobjectid = 8,
  properties = {},
  tilesets = {
    {
      name = "lofiEnvironment",
      firstgid = 1,
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/textures/lofiEnvironment.png",
      imagewidth = 128,
      imageheight = 128,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {}
    },
    {
      name = "lofiEnvironment2",
      firstgid = 257,
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/textures/lofiEnvironment2.png",
      imagewidth = 128,
      imageheight = 240,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      wangsets = {},
      tilecount = 480,
      tiles = {}
    },
    {
      name = "lofiObjBig",
      firstgid = 737,
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      columns = 32,
      image = "../../assets/textures/lofiObjBig.png",
      imagewidth = 256,
      imageheight = 512,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      wangsets = {},
      tilecount = 2048,
      tiles = {}
    },
    {
      name = "lofiObj3",
      firstgid = 2785,
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/textures/lofiObj3.png",
      imagewidth = 128,
      imageheight = 720,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      wangsets = {},
      tilecount = 1440,
      tiles = {}
    },
    {
      name = "lofiObj2",
      firstgid = 4225,
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/textures/lofiObj2.png",
      imagewidth = 128,
      imageheight = 176,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      wangsets = {},
      tilecount = 352,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      id = 1,
      name = "Tile Layer 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 82,
        82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "hover_ground",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "portal",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 32,
          width = 8,
          height = 8,
          rotation = 0,
          gid = 311,
          visible = true,
          properties = {
            ["portalId"] = "nexus"
          }
        },
        {
          id = 2,
          name = "chest",
          type = "",
          shape = "rectangle",
          x = 24,
          y = 56,
          width = 8,
          height = 8,
          rotation = 0,
          gid = 4197,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "chest",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 56,
          width = 8,
          height = 8,
          rotation = 0,
          gid = 4240,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "chest",
          type = "",
          shape = "rectangle",
          x = 56,
          y = 56,
          width = 8,
          height = 8,
          rotation = 0,
          gid = 4240,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "chest",
          type = "",
          shape = "rectangle",
          x = 72,
          y = 56,
          width = 8,
          height = 8,
          rotation = 0,
          gid = 4240,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "chest",
          type = "",
          shape = "rectangle",
          x = 88,
          y = 56,
          width = 8,
          height = 8,
          rotation = 0,
          gid = 4240,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "player",
          type = "",
          shape = "rectangle",
          x = 20.5,
          y = 26,
          width = 7,
          height = 7.25,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
