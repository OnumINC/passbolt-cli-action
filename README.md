# passbolt-cli-action
Passbolt cli github action

# How to use

Example:

```
      - uses: OnumINC/passbolt-cli-action@v0.2.2
        with:
          passbolt_url: ${{ secrets.PASSBOLT_URL }}
          password: ${{ secrets.PASSBOLT_PASS }}
          privatekey: ${{ secrets.PASSBOLT_PRIVKEY }}
          args: |
            list resource
```



