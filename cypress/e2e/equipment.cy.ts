describe('Equipment Management', () => {
  beforeEach(() => {
    // Assuming we have a test user
    cy.login('test@example.com', 'password123')
    cy.visit('/app/equipment')
  })

  it('should display equipment list', () => {
    cy.contains('Équipements disponibles').should('be.visible')
    cy.get('.grid').should('exist')
  })

  it('should filter equipment', () => {
    cy.get('input[placeholder="Rechercher un équipement..."]').type('MacBook')
    cy.get('.grid').should('contain', 'MacBook')
  })

  it('should sort equipment', () => {
    cy.get('select').first().select('nameDesc')
    cy.get('.grid').should('exist')
  })

  it('should show equipment details', () => {
    cy.get('.grid > div').first().within(() => {
      cy.get('img').should('be.visible')
      cy.get('h3').should('be.visible')
      cy.get('button').contains('Réserver').should('be.visible')
    })
  })
})