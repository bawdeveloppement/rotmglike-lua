
local World = require(_G.engineDir .. "world");
local Vault = require(_G.libDir .. "middleclass")("Vault", World);
local VaultData = require(_G.srcDir .. "worlds.vault.data")

function Vault:initialize ()
  World.initialize(self, "vault", VaultData);
end

return Vault
