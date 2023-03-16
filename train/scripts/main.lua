-- Codex 2.0.0 "Avocado"
-- example = spawn('example', rnd() * 3. - 1.5, 12, rnd() * 3. - 1.5)
sky()
fill('FF5')
gui()

function main()
    local tsize = 4
    model("choochoo", {
        t = { "train1", "train2" },
        q = { { -tsize, 0, 0 }, { tsize, 0, 0 }, { tsize, 0, tsize }, { -tsize, 0, tsize },
            { -tsize, 0, 0 }, { tsize, 0, 0 }, { tsize, -tsize, 0 }, { -tsize, -tsize, 0 }
        }
    })
    train = spawn("choochoo", 0, 20, 0)
    player = spawn('orange', 0, -5, 0)
    campos = { 0, 0, 5 }
    cam { pos = campos }
    player.offset = { 0, 0, .5 }
    player_speed = 0.1
    train_osculation = 0
    group(train, player)
    for i = -10, 10 do
        land(i * 20, 40)
    end
    -- spawn("orange", 0, 0, 0)
end

function land(x, b)
    model("liltree", { t = { "tree" }, q = { { -1, 0, 0 }, { 1, 0, 0 }, { 1, 0, 2 }, { -1, 0, 2 } } })
    for i = -10, 10 do
        for j = -10, 10 do
            local z = irnd(2)
            tile("grass", i + x, j + b, z)
            if irnd(10) == 0 then
                tile("liltree", i + x, j + b, z + 1)
            end
        end
    end
end

function loop()
    -- example.x = example.x + rnd() * 0.1 - 0.05
    -- example.z = example.z + rnd() * 0.1 - 0.05
    train_osculation = train_osculation + 0.1
    train.z = train.z + cos(train_osculation) * 0.1
    train.x = train.x + 0.1
    train.rz = cos(train_osculation) * 0.05

    local moving = false
    if key("a") then
        player.x = player.x - player_speed
        player:anim("orange.walk")
        player.flipped = true
        moving = true
    elseif key("d") then
        player.x = player.x + player_speed
        player:anim("orange.walk")
        player.flipped = false
        moving = true
    end

    if key('space') and player.z == 0 then
        player.vz = player.vz + 0.2
        player:anim("orange.jump")
    end
    if player.z <= 0 then
        player.z = 0.00001
        player:anim("orange.land")
    elseif not moving then
        player.tex = "orange0"
    end

    if player.z > 0 then
        player.vz = player.vz - 0.01
        player.z = player.z + player.vz
        if player.z < 0 then
            player.z = 0
            player.vz = 0
        end
    end
    campos[1] = campos[1] + 0.1
    cam { pos = campos }
    clr()
    text(flr(player.z * 100) / 100.)
end
