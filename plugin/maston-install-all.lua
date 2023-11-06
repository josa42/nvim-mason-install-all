vim.api.nvim_create_user_command('MasonInstallAll', function()
  local running = 0
  local done = function()
    running = running - 1
  end

  for _, pkg in ipairs(require('mason-registry').get_installed_packages()) do
    running = running + 1

    pkg:check_new_version(function(new_available)
      if new_available then
        pkg:install():on('closed', done)
      else
        done()
      end
    end)
  end

  vim.wait(10000, function()
    return running == 0
  end)
end, {})
